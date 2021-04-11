class Simulator
  property grav : Float64 = 9.81f64
  property normalized_accel : Float64
  property rest_length : Float64

  getter count : Int32
  getter mass : Float64
  getter spring_constant : Float64
  getter prev_states : StaticArray(State, 2)

  def initialize(count, mass, natural_length, spring_constant)
    @count = count.to_i32
    @mass = mass.to_f64
    @rest_length = natural_length.to_f64
    @spring_constant = spring_constant.to_f64
    @prev_states = StaticArray[start_state, start_state]
    @normalized_accel = @spring_constant / @mass
  end

  def step(dt)
    old_angle = @prev_states[0].angle

    # These coefficients are used to update the angle
    b, c, d = 0, 0, 0
    new_lengths = Array(Float64).new(@count, 0f64)

    @count.times do |mass_idx|
      # Update rod length first
      rod_angle = old_angle + mass_idx / @count * 2 * Math::PI
      # This expression is long, so i've split it over a few lines.
      numerator = (@normalized_accel - @grav * Math.sin(rod_angle)) * (dt ** 2)
      numerator += 2 * @prev_states[0].lengths[mass_idx] - @prev_states[1].lengths[mass_idx]

      denominator = 1 + @normalized_accel * (dt ** 2)

      # This is roughly subtracting the current derivative
      denominator += (@prev_states[1].angle - old_angle) ** 2

      r = numerator/denominator
      new_lengths[mass_idx] = r

      # Use the new rod length to update angle coefficients
      deriv = (r - @prev_states[0].lengths[mass_idx]) / dt
      second_deriv = (r - 2 * @prev_states[0].lengths[mass_idx] + @prev_states[1].lengths[mass_idx]) / (dt ** 2)
      b += deriv ** 2
      c += 2 * r * second_deriv
      d = @grav * r * Math.cos(rod_angle)
    end

    # Compute the new angle
    numerator = @prev_states[0].angle * c
    numerator += (2*@prev_states[0].angle - @prev_states[1].angle) / dt
    numerator -= d
    denominator = b / dt + c
    new_angle = numerator / denominator
    puts new_angle
    
    @prev_states[1] = @prev_states[0]
    @prev_states[0] = State.new(new_lengths, new_angle)
  end

  def start_state
    State.new(Array.new(@count, @rest_length), 0f64)
  end

  def state
    @prev_states[0]
  end

  record State,
    lengths : Array(Float64),
    angle : Float64
end
