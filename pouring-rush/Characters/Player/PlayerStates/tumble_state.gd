extends State
class_name TumbleState

@export var idle_state : State
@export var tech_state : State

var tumble_lock_timer : float = 0.2


func  on_enter():
	pass

func state_process(delta):
	
	if tumble_lock_timer > 0:
		tumble_lock_timer -= delta
		return
	
	if player.is_on_floor():
		next_state = idle_state
	


## Button Presses
func tech_button_pressed():
	if not player.can_tech:
		return
	check_tech()

func check_tech():
	if player.tech_zone != null:
		if player.tech_zone.has_overlapping_bodies():
			next_state = tech_state

func on_exit():
	player.in_tumble = false
	tumble_lock_timer = 0.2
