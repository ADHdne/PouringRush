extends State
class_name TumbleState

@export var idle_state : State
@export var tech_state : State


func  on_enter():
	player.in_tumble = true

func state_process(_delta):
	
	if player.movement.just_landed:
		next_state = idle_state
	

func state_input(event : InputEvent):
	if player.can_tech:
		if event.is_action_pressed("Block"):
			check_tech()

func check_tech():
	if player.tech_zone != null:
		if player.tech_zone.has_overlapping_bodies():
			next_state = tech_state

func on_exit():
	player.in_tumble = false
