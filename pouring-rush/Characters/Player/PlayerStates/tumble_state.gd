extends State
class_name TumbleState

@export var idle_state : State


var floor_timer : float = 0.1

func  on_enter():
	player.in_tumble = true


func state_process(_delta):
	
	
	if player.movement.just_landed:
		next_state = idle_state

func on_exit():
	player.in_tumble = false
