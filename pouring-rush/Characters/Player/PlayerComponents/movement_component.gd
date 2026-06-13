extends Node
class_name MovementComponent

## a components that holds all of the movement logic

@export var player : Player


## dash vars
var dash_timer = 0

# jump variables
var jumps_remaining : int = 1


func _process(delta: float) -> void:
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
	
	# moves player woth adding acceleration to direction
	if player.direction.x != 0 and player.state_machine.check_if_can_move() and player.can_action_pressed:
		accelerate(player.direction.x)
		if player.is_on_floor():
			if player.footstep_timer.time_left <= 0:
				#sound_effects.run()
				player.footstep_timer.start(0.15)
	else:
		add_friction()
		
	
	# bounce on walls in tumble
	if player.in_tumble:
		if player.is_on_wall():
			player.velocity.x * -1
		elif player.is_on_ceiling():
			player.velocity.y * -1
	
	player_movement()
	
	
	# dash timer
	if dash_timer > 0:
		dash_timer -= delta
	
	
	# reset jumps on landing
	if player.is_on_floor() and jumps_remaining != 1:
		jumps_remaining = 1
	
	


func accelerate(direction):
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, player.character_data.run_speed * direction, player.character_data.acc)
	else:
		player.velocity.x = move_toward(player.velocity.x, player.character_data.run_speed * direction, player.character_data.air_acc)

func add_friction():
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


func jump():
	player.velocity.y = player.character_data.jump_power

func wall_jump():
	player.velocity = Vector2(player.character_data.wall_jump_pushback * -player.direction.x, player.character_data.wall_jump_power)
