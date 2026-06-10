extends State
class_name FallState


@export var move_state : State
@export var idle_state : State
@export var jump_state : State
@export var wall_slide_state : State



func state_process(_delta):
	if player.is_on_floor():
		if player.direction.x == 0:
			next_state = idle_state
		elif player.direction.x != 0:
			next_state = move_state
	elif player.is_on_wall() and player.velocity.y > 0:
		next_state = wall_slide_state

func state_input(event : InputEvent):
	if event.is_action_pressed(player.player_actions.jump):
		if player.movement.jumps_remaining > 0:
			double_jump()
		else:
			player.jump_buffer_timer.start()

func double_jump():
	player.movement.jumps_remaining -= 1
	# the physical jump
	player.velocity.y = player.character_data.double_jump_power
	next_state = jump_state
