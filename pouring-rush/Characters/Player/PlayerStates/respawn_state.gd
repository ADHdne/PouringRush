extends State
class_name RespawnState

@export var idle_state : State


func on_enter():
	await get_tree().create_timer(1).timeout
	player.alive = true
	next_state = idle_state


func on_exit():
	player.can_action_pressed = true
