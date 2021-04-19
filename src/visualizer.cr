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

        if event.is_a? Event::MouseWheelScrollEvent
          new_angle = @simulator.log[0].angle + event.delta / 1000f64
          new_state = State.new(@simulator.log[0].lengths, new_angle)
          @simulator.log[0] = new_state
        end
      end

      window.clear(@background_color)

      draw(window)

      @simulator.step

      window.display
    end
  end

  def draw(window)
    center = vector2(400, 300)
    state = @simulator.state

    state.lengths.each_with_index do |length, idx|
      rod_angle_rad = state.angle + idx.to_f64 / @simulator.count * 2 * Math::PI
      rod_angle = - 180 / Math::PI * rod_angle_rad
      screen_length = length / 8
      rod = RectangleShape.new(vector2(screen_length.to_i32, 10))
      rod.fill_color = @rod_color
      rod.origin = vector2(0, 5)
      rod.rotate(rod_angle)
      rod.move(center)
      window.draw(rod)

      mass_radius = 10
      mass = CircleShape.new(mass_radius)
      mass.origin = vector2(mass_radius, mass_radius)
      mass.fill_color = @mass_color
      mass_angle = rod_angle_rad + Math::PI / 2
      mass.move(center + vector2(Math.sin(mass_angle), Math.cos(mass_angle)) * screen_length)
      window.draw(mass)
    end

    hub_diam = 25
    sides = @simulator.count
    sides = sides > 2 ? sides : 50
    hub = CircleShape.new(hub_diam, sides)
    hub.rotate(-state.angle * 180 / Math::PI - 90)
    hub.fill_color = @hub_color
    hub.origin = vector2(hub_diam, hub_diam)
    hub.move(center)
    window.draw hub
  end
end
