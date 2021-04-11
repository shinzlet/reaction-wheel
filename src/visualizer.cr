require "crsfml"
require "./simulator"

include SF

class Visualizer
  @background_color = SF.color(40, 40, 40)
  @rod_color = SF.color(150, 150, 150)
  @mass_color = SF.color(200, 125, 125)
  @hub_color = SF.color(80, 80, 80)

  def initialize(@simulator : Simulator)
  end

  def run
    window = RenderWindow.new(
      VideoMode.new(800, 600), "Reaction Wheel Simulation",
      settings: ContextSettings.new(depth: 24, antialiasing: 8)
    )

    while window.open?
      while event = window.poll_event
        if event.is_a? Event::Closed
          window.close
        end
      end

      window.clear(@background_color)

      draw(window)

      @simulator.step 0.00005

      window.display
    end
  end

  def draw(window)
    center = vector2(400, 300)
    state = @simulator.state

    state.lengths.each_with_index do |length, idx|
      rod_angle = -(state.angle * 180 / Math::PI + idx.to_f64 / @simulator.count * 360)
      rod = RectangleShape.new(vector2((length * 100).to_i32, 10))
      rod.fill_color = @rod_color
      rod.origin = vector2(0, 5)
      rod.rotate(rod_angle)
      rod.move(center)
      window.draw(rod)
    end

    hub_diam = 25
    sides = state.lengths.size
    sides = sides > 2 ? sides : 50
    hub = CircleShape.new(hub_diam, sides)
    if sides.even?
      hub.rotate(- state.angle * 180 / Math::PI + 180f64 / sides)
    else
      hub.rotate(- state.angle * 180 / Math::PI + 90f64 / sides)
    end
    hub.fill_color = @hub_color
    hub.origin = vector2(hub_diam, hub_diam)
    hub.move(center)
    window.draw hub
  end
end
