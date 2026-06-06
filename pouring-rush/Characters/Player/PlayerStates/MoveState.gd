extends State
class_name MoveState


# state reference
@export var jump_state : State
@export var idle_state : State


func on_enter():
	if not player.jump_buffer_timer.is_stopped():
		_jump()

func state_process(_delta):
	if player.is_on_floor() and player.direction.x == 0:
		next_state = idle_state


func state_input(event : InputEvent):
	if player.can_action_pressed:
		if event.is_action_pressed(player.player_actions.jump):
			_jump()


func _jump():
	player.movement.jump()
	next_state = jump_state
