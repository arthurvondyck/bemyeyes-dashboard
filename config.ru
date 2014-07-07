require 'active_support'
require 'active_support/core_ext'
require 'dashing'

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'

  helpers do
    def protected!
     config = YAML.load_file('config/config.yml')
    MongoMapper.connection = Mongo::Connection.new(config['database']['host'])
    MongoMapper.database = config['database']['name']
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
