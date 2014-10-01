# Populate the graph with some random points
require_relative '../lib/init'
points = []
(1..10).each do |i|
  points << { x: i, y: rand(50) }
end
last_x = points.last[:x]

SCHEDULER.every '1m' do
  points.shift
  last_x += 1
  points << { x: last_x, y:  Request.count}
  send_event('convergence', points: points)
end
