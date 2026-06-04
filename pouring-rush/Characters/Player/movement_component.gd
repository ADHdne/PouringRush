extends Node
class_name MovementComponent


@export var player : Player

# directions inputs
var direction = Vector2.ZERO
# can event action pressed
var can_action_pressed : bool = true

## dash vars
var dash_timer = 0

func _process(delta: float) -> void:
	## add gravity
	if not player.is_on_floor():
		## jump gravity
		if player.velocity.y < -0.1:
			player.velocity.y += player.properties.jump_gravity * delta
		## gravity at jumps peak
		elif player.velocity.y > -0.1 and player.velocity.y < 0.1:
			player.velocity.y += player.properties.jump_hang_gravity * delta
		## fall gravity
		else:
			player.velocity.y += player.properties.fall_gravity * delta
		## max fall velocity
		if player.velocity.y > player.properties.max_fall_velocity:
			player.velocity.y = player.properties.max_fall_velocity
	
	if player.movement.direction.x != 0 and player.state_machine.check_if_can_move() and player.movement.can_action_pressed:
		accelerate(direction.x)
		if player.is_on_floor():
			if player.footstep_timer.time_left <= 0:
				#sound_effects.run()
				player.footstep_timer.start(0.15)
	else:
		add_friction()
	player_movement()
	input()
	
		# dash timer
	if dash_timer > 0:
		dash_timer -= delta

func input() -> Vector2:
	direction = Input.get_vector(player.player_actions.move_left, player.player_actions.move_right, player.player_actions.move_up, player.player_actions.move_down)
	direction = direction.normalized()
	return direction

func accelerate(direction):
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, player.properties.run_speed * direction, player.properties.acc)
	else:
		player.velocity.x = move_toward(player.velocity.x, player.properties.run_speed * direction, player.properties.air_acc)

func add_friction():
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, player.properties.friction)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.properties.air_friction)
	
func player_movement():
	var was_on_the_flore = player.is_on_floor()
	player.move_and_slide()
	var just_left_ledge = was_on_the_flore and not player.is_on_floor() and player.velocity.y >= 0
	if just_left_ledge:
		player.coyote_jump_timer.start()


func jump():
	player.velocity.y = player.properties.jump_power
