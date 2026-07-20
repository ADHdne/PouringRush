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
	

func state_input(event : InputEvent):
	if event.is_action_pressed(player.input_handler.player_actions.block):
		check_can_tech()

func check_can_tech():
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
