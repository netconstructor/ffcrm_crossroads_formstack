# encoding: utf-8
require 'formstack'
require 'fat_free_crm/mail_processor/dropbox'

module FatFreeCRM
  module CrossroadsFormstack
    class FieldError < StandardError; end

    class Volunteers
      class << self
        def log(msg)
          puts msg
        end

        def settings
          begin
            @settings ||= YAML.load_file(::Rails.root.join('config/formstack_settings.yml'))
          rescue LoadError
            puts "Please run '$ ruby install.rb' in vendor/plugins/crm_crossroads_formstack and setup config."
            exit
          end
        end

        def client
          @client ||= Formstack::Client.new(settings["formstack"]["api_key"])
        end

        def formstack_form(form_id)
          if @current_form_id != form_id
            @current_form_id = form_id
            @form = client.form(form_id)
          end
          @form
        end

        def field_maps
          @field_maps ||= YAML.load_file(Engine.root.join("config", "field_maps.yml"))
        end

        def submission_errors
          tmp_file = Rails.root.join("tmp", "formstack_submission_errors.yml")
          @submission_errors ||= tmp_file.exist? ? YAML.load_file(tmp_file) : []
        end

        def add_submission_error(id)
          submission_errors << id
          File.open(Rails.root.join("tmp", "formstack_submission_errors.yml"), 'w') do |f|
            f.puts(submission_errors.to_yaml)
          end
        end

        # Looks up a field by name, and returns it's ID
        def field_id_from_name(name, form_id)
          field_maps[form_id][name].to_s
        end

        # Concatenates an Array of values into a formatted string
        def id_arr_to_s(id_array, submission)
          (id_array || []).map{|fid| submission[fid.to_s] }.join("\n")
        end

        # Concatenates a Hash of key/value pairs into a formatted string
        def id_hash_to_s(id_hash, submission)
          (id_hash || {}).sort.map{|label, fid| "#{label}:  #{submission[fid.to_s]}" }.join("\n")
        end

        def translate_chinese(string)
          # Translate chinese strings.
          {"星期二" => "tuesday",
          "星期三" => "wednesday",
          "星期四" => "thursday",
          "星期五" => "friday",
          "星期六" => "saturday",
          "不适合" => "not available",
          "全天" => "whole day",
          "上午" => "morning",
          "下午" => "afternoon",
          "不適合" => "not available",
          "英語" => "English",
          "廣東話" => "Cantonese",
          "普通話" => "Mandarin",
          "法語" => "French",
          "不會說" => "None",
          "初等水平" => "Basic",
          "熟練水平" => "Fluent",
          "英语" => "English",
          "广东话" => "Cantonese",
          "普通话" => "Mandarin",
          "法语" => "French",
          "不会说" => "None",
          "初等水平" => "Basic",
          "熟练水平" => "Fluent"}.each {|zh, en| string = string.gsub(zh, en)}
          string
        end

        # Map the submission to a usable hash.
        def submission_to_hash(s, form_id)
          # Build the field hash from the submission
          s = s.to_hash

          # Raise an exception if new fields have been added to the form.
          validate_no_new_fields(s, form_id)

          data = {"formstack_email" => {}}

          contact_params = {}
          %w(name email phone mobile).each do |field|
            contact_params[field] = s[field_id_from_name(field, form_id)].to_s
          end

          address = {}
          %w(country zipcode state street1 street2 city).each do |field|
            address[field] = s[field_id_from_name(field, form_id)].to_s
          end

          where_do_you_live = s[field_id_from_name("where_do_you_live", form_id)].to_s.strip
          if where_do_you_live == "Hong Kong" || where_do_you_live == "香港" || where_do_you_live.blank?
            address["country"] = "Hong Kong"
            address["state"] = s[field_id_from_name("hk_region", form_id)].to_s
          end

          contact_params["address"] = address

          data["formstack_email"]["contact"] = contact_params

          submission_params = {}
          %w(chinese_name salutation preferred_name age skills resume interests receive_emails why_would_you_like_to_volunteer
             how_did_you_hear_about_crossroads).each do |field|
            submission_params[field] = s[field_id_from_name(field, form_id)].to_s
          end
          # Some fields need to be translated from chinese:
          %w(languages_spoken availability).each do |field|
            submission_params[field] = translate_chinese(s[field_id_from_name(field, form_id)].to_s)
          end

          # Interested in doing contains many fields grouped together.
          submission_params["interested_in_doing"] = id_arr_to_s(field_maps[form_id]["interested_in_doing"], s)

          # Some fields are multiple formstack fields grouped together with labels.
          %w(school_or_company volunteering_type other_information).each do |field|
            submission_params[field] = id_hash_to_s(field_maps[form_id][field], s)
          end

          # Special case for internship form.
          if submission_params["other_information"].include?("Internship Period")
            submission_params["volunteering_type"] = "Internship"
          end

          data["formstack_email"]["formstack_submission"] = submission_params

          return data
        end

        # Returns an array of all field ids for the given form
        def all_form_field_ids(form_id)
          fields = []
          field_maps[form_id].each do |name, data|
            if data.is_a?(Hash)
              data.each {|k, v| fields << v }
            elsif data.is_a?(Array)
              fields += data
            else
              fields << data
            end
          end
          return fields.map(&:to_s)
        end

        # Validation (Checks that no new fields have been added.)
        # ----------------------------------------------------------------
        def validate_no_new_fields(sub, form_id)
          all_ids = all_form_field_ids(form_id)
          new_fields = sub["data"].select{|h| !all_ids.include?(h.field.to_s) }
          unless new_fields.empty?
            field_errors = new_fields.map{|h| "[#{h.field}: #{h.value}]"}.join(", ")
            raise FieldError, "The following fields have been added to form #{form_id} :: #{field_errors}"
          end
        end

        def process_new_submissions(dry_run = false)
          # Process submissions from each form.
          if @sender = User.find_by_email("volunteer@crossroads.org.hk")
            PaperTrail.whodunnit = @sender.id.to_s

            settings["formstack"]["form_ids"].each do |form_id|
              log "Fetching new submissions for form: #{form_id} ..."
              # Fetch submissions
              data = client.data(form_id, :per_page => 100)
              log "Processing #{data.submissions.size} submissions ..."
              data.submissions.each do |submission|
                # Don't retry the fail.
                unless submission_errors.include?(submission.id)
                  begin
                    submission_as_hash = submission_to_hash(submission, form_id)
                    # Log the submission for safe-keeping
                    log submission_as_hash.to_s

                    # Save the resume to disk, and return filepath
                    submission_as_hash["formstack_email"]["formstack_submission"]["resume"] = \
                      save_resume_to_disk(submission, form_id)

                    if process_formstack_submission(submission_as_hash, form_id)
                      if dry_run
                        puts "NOT deleting submission."
                        puts submission_as_hash
                      else
                        log "Deleting submission #{submission.id}..."
                        client.delete(submission.id)
                      end
                    end
                  rescue Exception => ex
                    if dry_run
                      puts "Error! :: #{ex.message}"
                    else
                      # Save submission errors so that bad records aren't processed continuously.
                      add_submission_error(submission.id)
                      HoptoadNotifier.notify(ex, :cgi_data => ENV)
                    end
                  end
                end
              end
            end
          else
            raise "Please create user with email: volunteer@crossroads.org.hk"
          end
        end

        # Process Formstack XML email. Permissions not applicable.
        #--------------------------------------------------------------------------------------
        def process_formstack_submission(data, form_id)
          contact_params = data["formstack_email"]["contact"]
          submission_params = data["formstack_email"]["formstack_submission"]

          # Check for a couple of fields that are most likely to fail.
          # Raise an exception (which notifies hoptoad) if they are blank.
          unless form_id.to_s == "1064470"  # Intern form has no availability field.
            if submission_params["availability"].blank?
              raise FieldError, "Field is blank: Availability"
            end
          end
          if submission_params["languages_spoken"].blank?
            raise FieldError, "Field is blank: Languages Spoken"
          end
          # If contact email address is already taken, create a new contact and add
          # a comment that points back to existing record.
          existing_contact = Contact.find_by_email(contact_params["email"].strip)

          log "Creating new contact: #{contact_params["email"]} <#{contact_params["name"]}> ..."
          log "Contact email has already been taken, creating contact with blank email." if existing_contact

          # Split up name into first and last names
          first_name, *last_name = contact_params.delete("name").split(' ')
          contact_params["first_name"], contact_params["last_name"] = first_name.titleize, last_name.join(' ').titleize
          contact_params["tag_list"] = "Volunteer"
          if submission_params["other_information"].include?("Internship Period")
            contact_params["tag_list"] << ", Intern"
          end

          # Set user and default access
          contact_params["user"] = @sender

          contact_params["access"] = FatFreeCRM::MailProcessor::Dropbox.new.send(:default_access)

          # Create contact with blank email if email is already taken.
          contact_params["email"] = nil if existing_contact

          # Pull out address param
          address = contact_params.delete("address")

          contact = Contact.create!(contact_params)

          # Find country code from name or 2 digit country code.
          countries_hash = ActionView::Helpers::FormOptionsHelper::COUNTRIES_HASH.invert
          country = address["country"].strip
          country_code = countries_hash[country].to_s
          country_code = country.upcase if country_code.blank? and country.size == 2

          # Sanitize address fields (strip and stringify)
          %w(street1 street2 city state zipcode).each {|f| address[f] = (address[f] || "").strip }

          Address.create!(:street1 => address["street1"],
                          :street2 => address["street2"],
                          :city    => address["city"],
                          :state   => address["state"],
                          :zipcode => address["zipcode"],
                          :country => country_code,
                          :address_type => "Business",
                          :addressable => contact)

          # Set 'Volunteer' customfield attributes to formstack_submission data
          # -------------------------------------------------------------------
          submission_params["availability"] = parse_availability(submission_params["availability"])
          submission_params["languages_spoken"] = parse_languages(submission_params["languages_spoken"])
          submission_params["email_subscriptions"] = ["Volunteer Email"] if submission_params["receive_emails"].present?


          # Strings
          %w(chinese_name salutation preferred_name age school_or_company skills resume interests volunteering_type
             why_would_you_like_to_volunteer how_did_you_hear_about_crossroads
             interested_in_doing other_information).each do |f|
              if contact.respond_to?("cf_#{f}=")
                contact.send("cf_#{f}=", (submission_params[f] || "").strip)
              else
                puts "!! Contact does not respond to method: cf_#{f}="
              end
          end

          # Arrays
          %w(availability languages_spoken email_subscriptions).each do |f|
              if contact.respond_to?("cf_#{f}=")
                contact.send("cf_#{f}=", submission_params[f] || [])
              else
                puts "!! Contact does not respond to method: cf_#{f}="
              end
          end

          contact.save!

          # Attach explanatory comments to both contacts if the email has
          # already been taken.
          # -------------------------------------------------------------------
          if existing_contact
            base_url = if (ENV["HOSTNAME"] || "").include?("-preview")
              "https://crm-preview.crossroadsint.org/contacts/"
            else
              "https://crm.crossroads.org.hk/contacts/"
            end

            Comment.create!(:commentable => existing_contact,
                            :user => @sender,
                            :comment => %Q{h3. Another person has signed up to volunteer using this contact's email address

      "#{contact.full_name}" (#{base_url}#{contact.id})  attempted to sign up using this contacts email address.

      Any further email correspondence relating to "#{contact.full_name}" will be attached to this record.})

            Comment.create!(:commentable => contact,
                            :user => @sender,
                            :comment => %Q{h3. Duplicate Email Address Notification

      The email address has been removed from this contact because they signed up to volunteer using the same email as "#{existing_contact.full_name}" (#{base_url}#{existing_contact.id})

      h3. Any further email correspondence will be attached to "#{existing_contact.full_name}"'s contact record.

      Please also note that this contact will not be able to use the volunteer sign-in terminal with the email address they signed up with.})
          end
          true
        end

        def parse_availability(string)
          return [] if string.blank?
          availability = []

          days_abbrev = {"tuesday"  => "Tues",
                        "wednesday" => "Wed",
                        "thursday"  => "Thurs",
                        "friday"    => "Fri",
                        "saturday"  => "Sat"}

          string.split("\n").each do |row|
            day, avail = *row.strip.split("=").map{|s| s.strip.downcase }
            if abbrev = days_abbrev[day]
              availability << "#{abbrev} Morning"   if ["morning",   "whole day"].include?(avail)
              availability << "#{abbrev} Afternoon" if ["afternoon", "whole day"].include?(avail)
            end
          end

          # Fallback if parsing fails.
          if availability.any?
            return availability
          else
            return string
          end
        end

        def parse_languages(string)
          return [] if string.blank?
          languages = []

          string.split("\n").each do |row|
            language, fluency = *row.strip.split("=").map{|s| s.strip }
            languages << "#{language} (#{fluency})" if %w(Basic Fluent).include?(fluency)
          end

          # Fallback if parsing fails.
          if languages.any?
            return languages
          else
            return string
          end
        end

        # Saves resume to ./public/formstack_resumes. Returns the filename
        def save_resume_to_disk(s, form_id)
          resume_url = s[field_id_from_name("resume", form_id)].to_s
          return "" if resume_url.blank?
          require 'net/http'
          require 'uri'

          file_ext = resume_url[/(\.[^.]+)$/, 1] || ""
          filename = "#{form_id}-#{s.id}#{file_ext}"
          filepath = File.join(Rails.root, "public", "formstack_resumes", filename)

          puts "== Downloading resume to '#{filepath}'..."

          url = URI.parse(resume_url)
          Net::HTTP.start(url.host, url.port) do |http|
            res = http.get(url.path)
            open(filepath, "wb") {|f| f.write(res.body) }
          end

          return "#{Setting.host}/formstack_resumes/#{filename}"
        end

      end
    end
  end
end
