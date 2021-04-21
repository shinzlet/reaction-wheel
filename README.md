# Superlinear Angular Momentum in Reaction Wheels

![The simulator in action](demonstration.gif)

This is my final project for PHYS 350 at UBC, wherein I develop several mathematical
models of expanding reaciton wheels. It is written in the context of robot control systems,
however the primary focus is on the lagrangian formalism used to describe such a system.

## Usage

To run the simulation, you must first install SFML, the Crystal compiler, and
`shards` (the Crystal) package manager. In the project directory, run `shards
install` to install dependencies, then run `crystal run src/reaction-wheel.cr`
to launch the visualizer. Graphing is done with `Ishi`, which requires `gnuplot`
to be installed on your system.

As implied in the instructions above, `reaction-wheel.cr` is what orchestrates
the simulation - if you want to tamper with this project, that's likely the place
to do so.

## Note

At the time of writing this, I'm currently juggling multiple final exams and this
project. Because this simulation was just something I made for my own interest,
it is poorly documented (although the code is not particularly complex).
