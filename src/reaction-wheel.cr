require "./visualizer"

simulator = Simulator.new(count: 5, mass: 1, natural_length: 0.5, spring_constant: 2000)
visualizer = Visualizer.new(simulator)
visualizer.run
