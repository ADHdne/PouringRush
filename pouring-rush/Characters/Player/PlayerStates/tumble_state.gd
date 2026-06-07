extends State
class_name TumbleState

@export var idle_state : State


func  on_enter():
	pass

func state_process(_delta):
	
	# showing color for how fast you are knocked back (tumble state)
	player.KO_component.check_killing_speed()
	
	# checking wall and ceiling and sending to ko component, and setting the was on surface flag to false
	if player.is_on_ceiling():
		player.KO_component.check_impact("Ceiling")
		player.can_tech = false
	elif player.is_on_wall():
		player.KO_component.check_impact("Wall")
		player.can_tech = false
	
	if player.movement.just_landed:
		next_state = idle_state

func state_input(event : InputEvent):
	if player.can_tech:
		if event.is_action_pressed("Block"):
			print("From Tumble: Player teched")
			# go to tech state and disable can_tech!


func on_exit():
	pass
