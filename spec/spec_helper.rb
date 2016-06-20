require "simplecov"
SimpleCov.start "rails" do
  add_filter "/.gems/"
end

ENV["RAILS_ENV"] ||= "test"

begin
  require File.expand_path("../dummy/config/environment", __FILE__)
rescue LoadError
  puts "Could not load dummy application."\
    "Please ensure you have run `bundle exec rake test_app`"
  exit
end

require "rspec/rails"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}
require "pry"
require "ffaker"
require "factory_girl_rails"
require "spree/testing_support/factories"
require "spree/testing_support/preferences"
require "spree/api/testing_support/helpers"
require "spree/api/testing_support/setup"
# require 'rspec/active_model/mocks'

RSpec.configure do |config|
  config.fail_fast = false
  config.filter_run focus: true
  config.infer_spec_type_from_file_location!
  config.mock_with :rspec
  config.raise_errors_for_deprecations!
  config.run_all_when_everything_filtered = true
  config.use_transactional_fixtures = true
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::Api::TestingSupport::Helpers, type: :controller
  config.extend Spree::Api::TestingSupport::Setup, type: :controller
  config.include Spree::TestingSupport::Preferences

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.before(:each) do
    Rails.cache.clear
    reset_spree_preferences
    Spree::Api::Config.requires_authentication = true
  end
end

Dir[File.join(File.dirname(__FILE__), "/support/**/*.rb")].each do |file|
  require file
end
