require_relative './init'


class Token
  include MongoMapper::Document

  key :user_id, ObjectId
  belongs_to :user, :class_name => "User"
  belongs_to :device, :class_name => "Device"
  

  key :token, String, :unique => true
  key :expiry_time, Time
  
  timestamps!
  
  before_create :generate_token
  before_create :calculate_expiry_time
  
  def to_json()
    return { "token" => self.token, "expiry_time" => self.expiry_time.utc.iso8601 }.to_json
  end
  
  def valid()
    return Time.now < self.expiry_date
  end
  
  def valid_time=(valid_time)
    @valid_time = valid_time
  end
  
  private
  def generate_token()
    self.token = SecureRandom.urlsafe_base64(64, false)
  end
  
  private
  def calculate_expiry_time()
    now = Time.now
    self.expiry_time = Time.new(now.year, now.month, now.day, 0, 0, 0) + @valid_time.to_i
  end
end
