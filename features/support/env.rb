require 'cucumber/rails'
require 'webmock'
require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'simplecov'
include WebMock::API
SimpleCov.start
WebMock.reset!
WebMock.enable!
WebMock.disable_net_connect!(:allow_localhost => true)
Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium

Capybara.register_driver :selenium do |app|
	Capybara::Selenium::Driver.new(app, browser: :chrome, :driver_path => 'features/support/chromedriver')
end

ActionController::Base.allow_rescue = false
Cucumber::Rails::Database.javascript_strategy = :truncation

