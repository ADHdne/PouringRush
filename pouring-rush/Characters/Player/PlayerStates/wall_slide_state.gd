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
	if player.can_action_pressed:
		if event.is_action_pressed(player.input_handler.player_actions.jump):
			wall_jump()

func wall_jump():
	player.movement_component.wall_jump()
	next_state = jump_state
