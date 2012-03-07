namespace :ffcrm do
  namespace :crossroads do
    namespace :formstack do
      desc "Fetch and process the latest form submissions from formstack."
      task :pull => :environment do
        # Set dryrun to true if Rails ENV is not production
        dryrun = (Rails.env != "production")
        require 'fat_free_crm/crossroads_formstack/volunteers'
        Volunteers.process_new_submissions(dryrun)
      end
      namespace :pull do
        desc "[Dry run] - Fetch and process the latest form submissions from formstack."
        task :dryrun => :environment do
          require 'fat_free_crm/crossroads_formstack/volunteers'
          Volunteers.process_new_submissions(:dryrun)
        end
      end
    end
  end
end

