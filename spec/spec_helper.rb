# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true


  #included for devise
  config.include Devise::TestHelpers, :type => :controller


  #helper methods
  def integration_sign_in(user)
    visit new_user_session_path
    fill_in :username, :with => user.username
    fill_in :password, :with => user.password
    click_button
  end


  def integration_valid_event_creation()
    visit new_event_path
    fill_in "Title", :with => "my_test_event"
    fill_in "Description", :with => "hello"
    fill_in "event_event_date", :with => "1-2-2011"
    fill_in "Initial Votes", :with => "20"
    click_button
  end




end
