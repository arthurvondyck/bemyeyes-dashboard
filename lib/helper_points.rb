require_relative './init'


class HelperPoint
  include MongoMapper::Document
  key :user_id, ObjectId
  key :log_time, Time
  key :point, Integer
  key :message, String

  belongs_to :user, :class_name => "User"
  before_create :generate_time
  
  def initialize(point, message, log_time = generate_time())
    self.point = point
    self.message = message
    self.log_time = log_time
  end

 def self.signup( )
   return HelperPoint.new(50, "signup")
 end

def self.answer_push_message( )
   return HelperPoint.new(5, "answer_push_message")
 end 

 def self.answer_push_message_technical_error( )
   return HelperPoint.new(10, "answer_push_message_technical_error")
 end 
 def self.finish_helping_request( )
   return HelperPoint.new(30, "finish_helping_request")
 end 

 def self.finish_10_helping_request_in_a_week( )
   return HelperPoint.new(30, "finish_10_helping_request_in_a_week")
 end 

 def self.finish_5_high_fives_in_a_week( )
   return HelperPoint.new(30, "finish_5_high_fives_in_a_week")
 end 
  def to_json()
    return { "point" => self.point, "log_time" => self.log_time.utc.iso8601 }.to_json
  end
  private
  def generate_time()
    self.log_time = Time.now
  end
end