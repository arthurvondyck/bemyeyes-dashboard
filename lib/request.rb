require_relative './init'


class Request
  include MongoMapper::Document

  belongs_to :blind, :class_name => "Blind"
  belongs_to :helper, :class_name => "Helper"
  many :helper_request, :foreign_key => :request_id, :class_name => "HelperRequest"
  one :abuse_report, :foreign_key => :abuse_report_id, :class_name => "AbuseReport"
  key :short_id, String
  key :session_id, String, :required => true
  key :token, String, :required => true
  key :answered, Boolean, :default => false 
  key :blind_rating, Integer
  key :helper_rating, Integer
  key :stopped, Boolean, :default => false 

  timestamps!

  before_create :create_short_id

  scope :unattended,  lambda { |older_than| where(:answered => false, :stopped => false) }

  def short_id_salt=(salt)
    @short_id_salt = salt
  end
  
  def to_json()
    return { "opentok" => {
               "session_id" => self.session_id,
               "token" => self.token
             },
             "id" => self._id,
             "short_id" => self.short_id,
             "ratings" => {
               "blind" => self.blind_rating,
               "helper" => self.helper_rating
             },
             "answered" => self.answered
           }.to_json
  end

  private
  def create_short_id
    self.short_id = self._id
  end
end
