require 'rubygems'
require 'bundler'
require 'rails/all'

Bundler.require :default, :development

require 'rspec/rails'

Combustion.initialize!
  
RSpec.configure do |config|
  config.use_transactional_fixtures = true
end

require File.dirname(__FILE__) + '/support/sample_formstack_submissions'

