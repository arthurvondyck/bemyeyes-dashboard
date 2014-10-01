require_relative '../lib/init'

current_valuation = 0
current_karma = 0


SCHEDULER.every '1m' do
  blind_user_ids = User.where(:role => "blind").collect {|blind| blind._id}.flatten
  sighted_user_ids = User.where(:role => "helper").collect {|blind| blind._id}.flatten

  blind_user_count = Token.where(:user_id => {:$in =>blind_user_ids}).count
  sighted_user_count = Token.where(:user_id => {:$in =>sighted_user_ids}).count

  send_event('sighted_logged_in',   { value: sighted_user_count })
  send_event('blind_logged_in', {value: blind_user_count})
  send_event('abuse_reports',   { value: AbuseReport.count })
end
