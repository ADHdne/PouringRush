extends State
class_name IdleState

@export var move_state : State
@export var Jump_state : State

func state_process(_delta):
	if not player.movement.direction.x == 0:
		next_state = move_state

func state_input(event : InputEvent):
	if player.movement.can_action_pressed:
		if event.is_action_pressed(player.player_actions.jump):
			player.movement.jump()
			next_state = Jump_state
