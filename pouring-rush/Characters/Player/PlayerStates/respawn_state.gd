extends State
class_name RespawnState

@export var idle_state : State

@export var alive_timer : Timer


func on_enter():
	alive_timer.start()



func _on_alive_timer_timeout() -> void:
	player.alive = true
	next_state = idle_state
	player.can_action_pressed = true
