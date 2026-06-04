extends State
class_name JumpState

@export var fall_state : State
@export var idle_state : State
@export var move_state : State

func on_enter():
	pass


func state_process(_delta):
	if not player.is_on_floor() and player.velocity.y > 0:
		next_state = fall_state
