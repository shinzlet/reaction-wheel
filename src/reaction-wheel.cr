require "./visualizer"

simulator = Simulator.new(count: 6, mass: 1, natural_length: 0.5, spring_constant: 200)
visualizer = Visualizer.new(simulator)
visualizer.run
