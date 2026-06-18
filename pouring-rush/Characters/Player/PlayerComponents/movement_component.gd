extends Node
class_name MovementComponent

## a components that holds all of the movement logic

@export var player : Player


var speed : float 

# dash vars
var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.ZERO

var dash_speed: float = 0.0
var dash_time_left: float = 0.0
var dash_duration: float = 0.2


# jump variables
var jumps_remaining : int = 1

# bouncing vars
var impact_vel : Vector2
var is_bouncing : bool = false




func _physics_process(delta: float) -> void:
	
	# normal movement
	player_movement()
	
	# applying dash
	if is_dashing:
		apply_dash(delta)
		return
	
	## add gravity
	if player.is_on_wall_only() and player.velocity.y > 0 and not player.in_tumble:
		## wall gravity
		player.velocity.y += player.character_data.wall_slide_gravity
		player.velocity.y = min(player.velocity.y, player.character_data.wall_slide_gravity)
	elif not player.is_on_floor():
		## jump gravity
		if player.velocity.y < -0.1:
			player.velocity.y += player.character_data.jump_gravity * delta
		## gravity at jumps peak
		elif player.velocity.y > -0.2 and player.velocity.y < 0.7:
			player.velocity.y += player.character_data.jump_hang_gravity * delta
		## fall gravity
		else:
			player.velocity.y += player.character_data.fall_gravity * delta
		## max fall velocity
		if player.velocity.y > player.character_data.max_fall_velocity:
			player.velocity.y = player.character_data.max_fall_velocity
	

	
	if player.in_tumble:
		if abs(player.velocity.x) >= 1:
			impact_vel = player.velocity
		check_bounce(impact_vel)
	
	
		# sets speed based on carrying or not
	if player.carry_component.is_carrying():
		speed = player.character_data.carry_speed
	else:
		speed = player.character_data.run_speed
	

	
	# moves player by adding acceleration to direction
	if player.direction.x != 0 and player.state_machine.check_if_can_move() and player.can_action_pressed:
		accelerate(player.direction.x)
		if player.is_on_floor():
			if player.footstep_timer.time_left <= 0:
				#sound_effects.run()
				player.footstep_timer.start(0.15)
	else:
		add_friction()
	
	# reset jumps on landing
	if player.is_on_floor() and jumps_remaining != 1:
		jumps_remaining = 1

func accelerate(direction):
	if player.in_tumble:
		return
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, speed * direction, player.character_data.acc)
	else:
		player.velocity.x = move_toward(player.velocity.x, speed * direction, player.character_data.air_acc)

func add_friction():
	if player.in_tumble:
		return
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, player.character_data.friction)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.character_data.air_friction)
	
func player_movement():
	var was_on_the_flore = player.is_on_floor()
	player.move_and_slide()
	var just_left_ledge = was_on_the_flore and not player.is_on_floor() and player.velocity.y >= 0
	if just_left_ledge:
		player.coyote_jump_timer.start()


func check_bounce(vel : Vector2):
	
	for i in range(player.get_slide_collision_count()):

		var collision = player.get_slide_collision(i)

		if collision == null:
			continue

		var normal = collision.get_normal()

		# Wall bounce
		if abs(normal.x) > 0.9:
			is_bouncing = true
			# Only bounce if moving fast enough
			if abs(vel.x) > 200:
				player.velocity.x = vel.x * -0.6

		# Ceiling bounce
		elif normal.y > 0.9:
			is_bouncing = true
			if abs(vel.y) > 200:
				player.velocity.y =  vel.y * -0.6

func jump():
	player.velocity.y = player.character_data.jump_power

func wall_jump():
	player.velocity = Vector2(player.character_data.wall_jump_pushback * -player.direction.x, player.character_data.wall_jump_power)

func start_dash(direction : Vector2, speed : float, duration : float):
	
	if direction == Vector2.ZERO:
		return
	
	is_dashing = true
	dash_direction = direction.normalized()
	
	dash_speed = speed
	dash_duration = duration
	dash_time_left = duration

func apply_dash(delta: float):

	player.velocity = dash_direction * dash_speed

	dash_time_left -= delta
	
	if dash_time_left <= 0:
		end_dash()

func end_dash():
	is_dashing = false
	dash_direction = Vector2.ZERO
	dash_speed = 0.0
