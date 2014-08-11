require_relative '../lib/init'

current_valuation = 0
current_karma = 0


SCHEDULER.every '1m' do
  MongoMapper.connection = Mongo::Connection.new("localhost")
  MongoMapper.database = 'bemyeyes'
  last_valuation = current_valuation
  last_karma     = current_karma
  current_valuation = rand(100)
  current_karma     = rand(200000)


  send_event('valuation', { current: current_valuation, last: last_valuation })
  send_event('sighted_logged_in',   { value: Token.count })
  send_event('blind_logged_in', {value: 42})
  send_event('abuse_reports',   { value: AbuseReport.count })
end
