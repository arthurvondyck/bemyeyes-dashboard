require_relative './init'

class AbuseReport
  include MongoMapper::Document
  belongs_to :request, :class_name => "Request"
  belongs_to :blind, :class_name => "Blind"
  belongs_to :helper, :class_name => "Helper"
  key :reason, String, :required => true
  key :reporter, String, :required => true
  timestamps!

  after_save :three_strikes_and_you_are_out
  def three_strikes_and_you_are_out
    if reporter == "blind"
      if helper.nil?
        return
      end
      no_of_abuses = AbuseReport.where(:helper_id => helper.id).count
      if no_of_abuses == 3
        helper.blocked = true
      end
    else
      if blind.nil?
        return
      end
      no_of_abuses = AbuseReport.where(:blind_id => blind.id).count
      if no_of_abuses == 3
        blind.blocked = true
      end
    end

  end
end
