ENV['RACK_ENV'] = 'test'
ENV['DEBOX_ROOT'] = File.join(File.dirname(__FILE__), '../')

require 'rubygems'
require 'bundler'
require 'rack'
require 'thin'
require 'debox_server'
require 'debox_server/api'
require 'database_cleaner'
Bundler.require

require "debox/cli"
require 'rspec/mocks'

# Setup mocks
RSpec::Mocks::setup(Object.new)

# Load commands
Debox::Command.load

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# Start a debox server for tests
DEBOX_SERVER_PORT = 9393
debox_server_start DEBOX_SERVER_PORT

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  # Cleanup database after each test
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
