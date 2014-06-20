require_relative './init'


require 'securerandom'

class ResetPasswordToken 
  include MongoMapper::Document

  belongs_to :user, :class_name => "User"
  key :token, String, :unique => true
  timestamps!

  before_save :create_unique_id

  def create_unique_id
    unless self.token
      unique_id =  SecureRandom.uuid
      self.token = unique_id
    end
  end
end
