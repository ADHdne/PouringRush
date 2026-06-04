extends State
class_name FallState


@export var move_state : State
@export var idle_state : State
@export var jump_state : State



func state_process(_delta):
	if player.is_on_floor():
		if player.movement.direction.x == 0:
			next_state = idle_state
		elif player.movement.direction.x != 0:
			next_state = move_state
