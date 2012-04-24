source :rubygems

require File.expand_path('../lib/bundler/gem_development', __FILE__)
Bundler.development_gems = ['fat_free_crm', /^ffcrm_/]

gemspec

gem 'fat_free_crm', :git => 'git://github.com/fatfreecrm/fat_free_crm.git'
gem 'formstack'

gem 'pg'  # Default database for testing

group :test do
  gem 'rspec'
  gem 'combustion'
  unless ENV["CI"]
    gem 'ruby-debug',   :platform => :mri_18
    gem 'debugger',     :platform => :mri_19
  end
end
