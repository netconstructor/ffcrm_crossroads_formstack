source :rubygems

require File.expand_path('../lib/bundler/gem_development', __FILE__)
Bundler.development_gems = ['fat_free_crm', /^ffcrm_/]

gemspec

gem 'fat_free_crm', :git => 'git://github.com/fatfreecrm/fat_free_crm.git', :branch => 'paper'
gem 'formstack'
gem 'ffcrm_crossroads', :git => 'git@bitbucket.org:crossroadsIT/ffcrm_crossroads.git', :branch => 'gem'

gem 'pg'  # Default database for testing

group :test do
  gem 'rspec'
  gem 'combustion'
  gem 'ruby-debug',   :platform => :mri_18
  gem 'ruby-debug19', :platform => :mri_19
end