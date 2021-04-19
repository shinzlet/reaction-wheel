class Simulator
  property grav : Float64 = 200.81f64
  property frequency : Float64
  property rest_length : Float64

  getter count : Int32
  getter mass : Float64
  getter spring_constant : Float64
  getter log : StaticArray(State, 2)
  getter timestep : Float64

  def initialize(count, mass, natural_length, spring_constant, @timestep = 0.001f64)
    @count = count.to_i32
    @mass = mass.to_f64
    @rest_length = natural_length.to_f64
    @spring_constant = spring_constant.to_f64
    @log = StaticArray[start_state, start_state(0.005f64)]
    @frequency = Math.sqrt(@spring_constant / @mass)
  end

  def step(dt = @timestep)
    # These coefficients are used in the angle calculation
    half_dt_alpha, beta, gamma = 0f64, 0f64, 0f64

    new_lengths = Array(Float64).new(@count, 0f64)
    @count.times do |i|
      rod_angle = @log[0].angle + 2 * Math::PI * i / @count

      # This is all derived from finite difference approximations of the
      # euler-lagrange equations
      new_length = 2 * @log[0].lengths[i] - @log[1].lengths[i]
      new_length += (@log[0].angle - @log[1].angle) ** 2 * @log[0].lengths[i]
      new_length += ((@frequency * dt) ** 2) * (@rest_length - @log[0].lengths[i])
      new_length -= @grav * Math.sin(rod_angle) * (dt ** 2)

      new_lengths[i] = new_length

      half_dt_alpha += 2 * @log[0].lengths[i] * (@log[0].lengths[i] - @log[1].lengths[i])
      beta += @log[0].lengths[i] ** 2
      gamma += @log[0].lengths[i] * Math.cos(rod_angle)
    end

    # Construct the angle in parts because the expression is quite long
    new_angle = (2 * beta - 2 * half_dt_alpha) * @log[0].angle
    new_angle += (2 * half_dt_alpha - beta) * @log[1].angle
    new_angle -= @grav * gamma * (dt ** 2)
    new_angle /= beta

    @log[1] = @log[0]
    @log[0] = State.new(new_lengths, new_angle)
  end

  def start_state(angle = 0f64)
    State.new(Array.new(@count, @rest_length / 1.2), angle)
  end

  def state
    @log[0]
  end
end

record State,
  lengths : Array(Float64),
  angle : Float64
