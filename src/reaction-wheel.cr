require "./simulator"
require "./visualizer"

simulator = Simulator.new(count: 5, mass: 1, natural_length: 500, spring_constant: 10, timestep: 0.01)

lengths = Array(Float64).new

simulator.count.times do |idx|
  lengths << Random.rand * simulator.rest_length / 2 + simulator.rest_length * 2 / 3
end

simulator.log[0] = State.new(lengths, 0f64)
simulator.log[1] = State.new(lengths, simulator.timestep * Random.rand)

visualizer = Visualizer.new(simulator)
visualizer.run
