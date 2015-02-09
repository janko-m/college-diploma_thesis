ENV["RACK_ENV"] = "test"

require "minitest"

require "rack/test"
require "database_cleaner"
require "pry"

require "./app"

DatabaseCleaner.strategy = :transaction

Before { DatabaseCleaner.start }
After  { DatabaseCleaner.clean }

World Rack::Test::Methods
World Module.new {
  def app
    Crosbi.set :show_exceptions, false
    Crosbi.new
  end
}
