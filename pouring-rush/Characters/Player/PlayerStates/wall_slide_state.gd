extends State
class_name WallSlideState


@export var fall_state : State
@export var jump_state : State
@export var idle_state : State


func state_process(_delta):
	if not player.is_on_wall():
		if player.is_on_floor():
			next_state = idle_state
		else:
			next_state = fall_state
	else:
		pass

func state_input(event : InputEvent):
	if event.is_action_pressed(player.player_actions.jump):
		jump()

func jump():
	player.movement.jump()
	next_state = jump_state
