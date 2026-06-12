extends State
class_name PutDownState

@export var idle_state : State

func on_enter():
	await get_tree().create_timer(1).timeout
	next_state = idle_state
