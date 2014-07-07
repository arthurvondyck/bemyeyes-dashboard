require 'active_support'
require 'active_support/core_ext'
require 'dashing'

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'

  helpers do
    def protected!
    MongoMapper.connection = Mongo::Connection.new(ENV['databasehost'])
    MongoMapper.database = ENV['databasename']
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
