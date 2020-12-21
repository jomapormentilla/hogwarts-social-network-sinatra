ENV['SINATRA_ENV'] ||= "development"

require 'bundler'
Bundler.require(:default, ENV['SINATRA_ENV'])

require 'sinatra'
set :database_file, "./database.yml"

# ActiveRecord::Base.establish_connection(
#   :adapter => "sqlite3",
#   :database => "db/#{ENV['SINATRA_ENV']}.db"
# )

Dotenv.load if ENV['SINATRA_ENV'] == "development"

require 'open-uri'
require_all 'app'