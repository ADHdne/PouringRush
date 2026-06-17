extends State
class_name PutDownState

@export var idle_state : State

@export var lag : float = 0.3

func on_enter():
	await get_tree().create_timer(lag).timeout
	next_state = idle_state
