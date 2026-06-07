extends State
class_name TumbleState

@export var idle_state : State


var floor_timer : float = 0.1

func  on_enter():
	player.in_tumble = true


func state_process(_delta):
	
	# showing color for how fast you are knocked back (tumble state)
	player.KO_component.check_killing_speed()
	
	# checking wall and ceiling and sending to ko component
	if player.is_on_wall():
		player.KO_component.check_impact()
	elif player.is_on_ceiling():
		player.KO_component.check_impact()
	
	if player.movement.just_landed:
		next_state = idle_state

func on_exit():
	player.in_tumble = false
