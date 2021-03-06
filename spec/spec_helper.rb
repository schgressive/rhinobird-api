require 'rubygems'
require 'coveralls'
Coveralls.wear!('rails')
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require "paperclip/matchers"
require 'shoulda/matchers/integrations/rspec'
require 'email_spec'
require 'fb_graph/mock'
require 'sidekiq/testing'
include FbGraph::Mock

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_framework = :rspec

  # Infer spec types from file locations
  config.infer_spec_type_from_file_location!

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false


  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.before(:suite) do
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    # Clears out the jobs for tests using the fake testing
    Sidekiq::Worker.clear_all

    if RSpec.current_example.metadata[:sidekiq] == :fake
      Sidekiq::Testing.fake!
    elsif RSpec.current_example.metadata[:sidekiq] == :inline
      Sidekiq::Testing.inline!
    elsif RSpec.current_example.metadata[:type] == :feature
      Sidekiq::Testing.inline!
    else
      Sidekiq::Testing.fake!
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  config.include Devise::TestHelpers, :type => :controller
  config.include FactoryGirl::Syntax::Methods
  config.include Paperclip::Shoulda::Matchers
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.extend ControllerMacros, :type => :controller
end



