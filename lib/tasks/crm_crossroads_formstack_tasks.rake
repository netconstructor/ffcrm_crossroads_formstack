namespace :crm do
  namespace :crossroads do
    namespace :formstack do
      desc "Fetch and process the latest form submissions from formstack."
      task :pull => :environment do
        require 'formstack'
        require 'volunteers_formstack'
        VolunteersFormstack.process_new_submissions
      end
    end
  end
end

