require 'bcrypt'
require_relative './init'


class User
  include MongoMapper::Document
  SCHEMA = {
      "type" => "object",
      "required" => [],
      "additionalProperties" => false,
      "properties" => {
          "user_id" => {"type" => "integer"},
          "password" => {"type" => "string"},
          "email" => {"type" => "string"},
          "first_name" => {"type" => "string"},
          "last_name" => {"type" => "string"},
          "role" => {"type" => "string"},
          "languages" => {"type" => "array"},
      }
  }

  many :tokens, :foreign_key => :user_id, :class_name => "Token"
  many :devices, :foreign_key => :user_id, :class_name => "Device"
  one :reset_password_token, :foreign_key => :reset_password_token_id, :class_name => "ResetPasswordToken"  
  
  key :password_hash, String
  key :password_salt, String
  key :email, String, :required => true, :unique => true
  key :first_name, String, :required => true
  key :last_name, String, :required => true
  key :languages, Array, :default => ["da","en"]
  key :user_id, Integer, :unique => true #, :required => true #Unique identifier from FB
  key :role, String, :required => true
  key :available_from, Time
  key :snooze_period, String
  key :blocked, Boolean, :default => false
  key :is_external_user, Boolean, :default => false
  timestamps!
  
  before_save :encrypt_password
  before_create :set_unique_id

  # dynamic scopes
  scope :by_languages,  lambda { |languages| where(:languages => { :$in => languages }) }

  def self.authenticate_using_email(email, password)
    user = User.first(:email => { :$regex => /#{Regexp.escape(email)}/i })
    if !user.nil?
      return authenticate_password(user, password)
    end
    
    return nil
  end
  
  def self.authenticate_using_user_id(email, user_id)
    user = User.first(:user_id => user_id)
    if !user.nil?
      return user
    end
    
    return nil
  end

  def password=(pwd)
    @password = pwd
  end

  def snooze
    if self.available_from && Time.now.utc < self.available_from
      { "period" => self.snooze_period,
        "until" => self.available_from
      }
    else
      nil
    end
  end

  def to_json()
    return { "id" => self._id,
             "user_id" => self.user_id,
             "email" => self.email,
             "first_name" => self.first_name,
             "last_name" => self.last_name,
             "role" => self.role,
             "languages" => self.languages,
             "snooze" => self.snooze
    }.to_json
  end

  def to_s
    "#{self.first_name}"
  end

  private
  def self.authenticate_password(user, password)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      return user
    end
    
    return nil
  end

  def encrypt_password
    if @password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(@password, password_salt)
    end
  end

  def generate_unique_id
    rand = ("817173" + rand(9999999).to_s.center(8, rand(9).to_s)).to_i
    if User.where(:user_id => rand).count > 0
      generate_unique_id
    else
      return rand
    end
  end

  def set_unique_id
    unless self.user_id
      unique_id =  generate_unique_id
      self.user_id = unique_id
    end
  end
end
