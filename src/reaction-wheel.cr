require "ishi/png"

require "./simulator"
require "./visualizer"

# simulator = Simulator.new(count: 5, mass: 0.01, natural_length: 0.3, spring_constant: 20, timestep: 0.002f64)
simulator = Simulator.new(count: 5, mass: 1, natural_length: 500, spring_constant: 20, timestep: 0.005f64)

lengths = Array(Float64).new

simulator.count.times do |idx|
  lengths << Random.rand * simulator.rest_length / 2 + simulator.rest_length * 2 / 3
end

simulator.log[1] = State.new(lengths, 0f64)
simulator.log[0] = State.new(lengths, simulator.timestep / 2)

visualizer = Visualizer.new(simulator)

momentum = [] of Float64
angular_vel = [] of Float64
counter = 0
period = 1
stop = 15000

begin
  visualizer.run
  visualizer.run do |sim|
    # Force our angle function
    if counter < stop / 2
      sim.log[0] = State.new(sim.log[0].lengths, 0.5 * sim.time**2)
    end

    # Data collection
    if counter % period == 0
      momentum << sim.angular_momentum
      angular_vel << sim.angular_vel
    end

    # stop the sim once enough data is collected
    counter += 1
    counter > stop
  end
rescue ex : OverflowError
  puts "Overflowed at #{counter}/#{stop}"
end

# Remove outliers
sorted = momentum.sort
sorted.last(10).each do |value|
  idx = momentum.index(value) || -1
  momentum.delete_at(idx)
  angular_vel.delete_at(idx)
end

param_string = String.build do |builder|
  builder << "N=#{simulator.count},"
  builder << "m=#{simulator.mass}kg,"
  builder << "L0=#{simulator.rest_length}m"
  builder << "k=#{simulator.spring_constant}N/m"
end

outfile = File.new("test.png", mode="w")
Ishi.new(outfile) do
  plot(angular_vel, momentum, style: :lines, 
      title: "Quadratic forcing (#{param_string})")
    .xlabel("Angular Velocity (radians/s)")
    .ylabel("Angular Momentum (kg m^2 / s)")
  show
end
outfile.flush
