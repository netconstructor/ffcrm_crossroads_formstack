namespace :crm do
  namespace :crossroads do
    namespace :formstack do
      desc "Fetch and process the latest form submissions from formstack."
      task :pull => :environment do
        require 'formstack'
        require 'volunteers_formstack'
        # Set dryrun to true if Rails ENV is not production
        dryrun = (Rails.env != "production")
        VolunteersFormstack.process_new_submissions(dryrun)
      end
      namespace :pull do
        desc "[Dry run] - Fetch and process the latest form submissions from formstack."
        task :dryrun => :environment do
          require 'formstack'
          require 'volunteers_formstack'
          VolunteersFormstack.process_new_submissions(:dryrun)
        end
      end
    end
  end
end

