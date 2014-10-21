require "mongo"
include Mongo

SCHEDULER.every '1m', :first_in => 0 do
  blind_above_1_calls = find_count_above 1
  send_event('blind_above_1_calls',   { value: blind_above_1_calls })

  blind_above_5_calls = find_count_above 5
  send_event('blind_above_5_calls',   { value: blind_above_5_calls })

  blind_above_10_calls = find_count_above 10
  send_event('blind_above_10_calls',   { value: blind_above_10_calls })
end

def find_count_above(limit)
  db = MongoClient.new("localhost", 27017, w: 1).db("bemyeyes")
  coll = db.collection("requests")
  coll.aggregate([
    {"$group" => {_id: "$blind_id", count: {"$sum" => 1}}},
    {"$match" => {count: {"$gte" => limit}}}
    ]).count
end
