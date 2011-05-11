# encoding: utf-8

class VolunteersFormstack
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
      @field_maps ||= YAML.load_file(File.join(File.dirname(__FILE__), "field_maps.yml"))
    end

    def field_id_from_name(name, form_id)
      field_maps[form_id][name].to_s
    end

    def id_arr_to_s(id_array, submission)
      (id_array || []).map{|fid| submission[fid.to_s] }.join("\n")
    end

    def id_hash_to_s(id_hash, submission)
      (id_hash || []).map{|label, fid| "#{label}:  #{submission[fid.to_s]}" }.join("\n")
    end

    # Map the submission to a usable hash.
    def submission_to_hash(s, form_id)
      # Build the field hash from the submission
      s = s.to_hash
      data = {"formstack_email" => {}}

      contact_params = {}
      %w(name email phone mobile chinese_name salutation preferred_name).each do |field|
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
      %w(skills resume interests languages_spoken
         availability receive_emails why_would_you_like_to_volunteer
         how_did_you_hear_about_crossroads).each do |field|
        submission_params[field] = s[field_id_from_name(field, form_id)].to_s
      end

      # Interested in doing contains many fields grouped together.
      submission_params["interested_in_doing"] = id_arr_to_s(field_maps[form_id]["interested_in_doing"], s)

      # Some fields are multiple formstack fields grouped together with labels.
      %w(school_or_company volunteering_type other_information).each do |field|
        submission_params[field] = id_hash_to_s(field_maps[form_id][field], s)
      end

      data["formstack_email"]["formstack_submission"] = submission_params

      return data
    end

    def process_new_submissions
      # Process submissions from each form.
      if @sender = User.find_by_email("volunteer@crossroads.org.hk")
        settings["formstack"]["form_ids"].each do |form_id|
          log "Fetching new submissions for form: #{form_id} ..."
          # Fetch submissions
          data = client.data(form_id, :per_page => 100)
          log "Processing #{data.submissions.size} submissions ..."
          data.submissions.each do |submission|
            begin
              submission_as_hash = submission_to_hash(submission, form_id)
              # Log the submission for safe-keeping
              log submission_as_hash.to_s

              if process_formstack_submission(submission_as_hash)
                log "Deleting submission #{submission.id}..."
                client.delete(submission.id)
              end
            rescue Exception => ex
              HoptoadNotifier.notify(ex, :cgi_data => ENV)
            end
          end
        end
      else
        raise "Please create user with email: volunteer@crossroads.org.hk"
      end
    end

    # Process Formstack XML email. Permissions not applicable.
    #--------------------------------------------------------------------------------------
    def process_formstack_submission(data)
      # Set User.current_user so that ActivityObserver works.
      User.current_user = @sender

      contact_params = data["formstack_email"]["contact"]
      submission = data["formstack_email"]["formstack_submission"]

      # If contact email address is already taken, create a new contact and add
      # a comment that points back to existing record.
      existing_contact = Contact.find_by_email(contact_params["email"].strip)

      log "Creating new contact: #{contact_params["email"]} <#{contact_params["name"]}> ..."
      log "Contact email has already been taken, creating contact with blank email." if existing_contact

      # Split up name into first and last names
      first_name, *last_name = contact_params.delete("name").split(' ')
      contact_params["first_name"], contact_params["last_name"] = first_name.titleize, last_name.join(' ').titleize
      contact_params["tag_list"] = "Volunteer"
      contact_params["email_subscriptions"] = ["Volunteer Email"] if !submission["receive_emails"].blank?

      # Set user and default access
      contact_params["user"] = @sender
      contact_params["access"] = FatFreeCRM::Dropbox.new.send(:default_access)

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
      vol_tag = contact.tag("Volunteer")

      vol_tag.availability = parse_availability(submission["availability"])
      vol_tag.languages_spoken = parse_languages(submission["languages_spoken"])

      %w(school_or_company skills resume interests volunteering_type
         why_would_you_like_to_volunteer how_did_you_hear_about_crossroads
         interested_in_doing other_information).each do |f|
            if vol_tag.respond_to?("#{f}=")
              vol_tag.send("#{f}=", (submission[f] || "").strip)
            end
      end
      vol_tag.save!

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
      availability
    end

    def parse_languages(string)
      return [] if string.blank?
      languages = []
      string.split("\n").each do |row|
        language, fluency = *row.strip.split("=").map{|s| s.strip }
        languages << "#{language} (#{fluency})" unless fluency == "None"
      end
      languages
    end


  end
end

