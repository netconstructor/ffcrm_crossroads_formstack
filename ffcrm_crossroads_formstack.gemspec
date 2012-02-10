# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'ffcrm_crossroads_formstack/version'

Gem::Specification.new do |s|
  s.name = 'ffcrm_crossroads_formstack'
  s.authors = ['Nathan Broadbent']
  s.summary = 'Fat Free CRM - Crossroads Formstack'
  s.description = 'Fat Free CRM - Crossroads Formstack'
  s.files = `git ls-files`.split("\n")
  s.version = FatFreeCRM::CrossroadsFormstack::VERSION

  s.add_development_dependency 'rspec-rails', '~> 2.6'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'combustion'
  s.add_dependency 'fat_free_crm'
  s.add_dependency 'formstack'
end
