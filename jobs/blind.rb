require "mongo"
include Mongo

SCHEDULER.every '1m', :first_in => 0 do
  db = MongoClient.new("localhost", 27017, w: 1).db("bemyeyes")
  coll = db.collection("users")

  blind_above_5_calls = coll.aggregate([
  {"$group" => {_id: "$state", count: {"$sum" => 1}}},
  {"$match" => {count: {"$gte" => 5}}}
])
end
