require "./visualizer"

simulator = Simulator.new(count: 5, mass: 1, natural_length: 500, spring_constant: 100, timestep: 0.01)
visualizer = Visualizer.new(simulator)
visualizer.run
