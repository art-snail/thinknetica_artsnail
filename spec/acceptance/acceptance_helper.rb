require 'rails_helper'

RSpec.configure do |config|
  Capybara.server = :puma
  Capybara.server_port = 3030

  config.use_transactional_fixtures = false

  config.include AcceptanceMacros, type: :feature

  Capybara.javascript_driver = :webkit

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end