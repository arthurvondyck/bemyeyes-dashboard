require_relative './init'


class Device
  include MongoMapper::Document

  belongs_to :user, :class_name => "User"

  key :device_token, String, :required => true
  one :token, :foreign_key => :token_id, :class_name => "Token"
  key :device_name, String
  key :model, String
  key :system_version, String
  key :app_version, String
  key :app_bundle_version, String
  key :locale, String
  key :development, Boolean, :default => false
  
  timestamps!
  def is_logged_in
    !token.nil?
  end
end
