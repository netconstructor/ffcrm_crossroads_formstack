namespace :ffcrm do
  namespace :crossroads do
    namespace :formstack do
      desc "Fetch and process the latest form submissions from formstack."
      task :pull => :environment do
        # Set dry_run to true if Rails ENV is not production
        dry_run = (Rails.env != "production")
        require 'fat_free_crm/crossroads_formstack/volunteers'
        FatFreeCRM::CrossroadsFormstack::Volunteers.process_new_submissions(dry_run)
      end
      namespace :pull do
        desc "[Dry run] - Fetch and process the latest form submissions from formstack."
        task :dry_run => :environment do
          require 'fat_free_crm/crossroads_formstack/volunteers'
          FatFreeCRM::CrossroadsFormstack::Volunteers.process_new_submissions(:dry_run)
        end
      end
    end
  end
end

