require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

ENV["SINATRA_ENV"] = "test"

require_relative '../config/environment'
require 'rack/test'
require 'capybara/rspec'
require 'capybara/dsl'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate SINATRA_ENV=test` to resolve the issue.'
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include Rack::Test::Methods
  config.include Capybara::DSL

  config.before(:all) do
    @bear = User.create(username: "Bear", password: "honey")
    @alex = User.create(username: "Alex", password: "password")
    @amanda = User.create(username: "Amanda", password: "password")
  end

  DatabaseCleaner.strategy = :truncation

  config.after(:all) do 
    DatabaseCleaner.clean
  end

  config.order = 'default'
end

def app
  Rack::Builder.parse_file('config.ru').first
end

Capybara.app = app 