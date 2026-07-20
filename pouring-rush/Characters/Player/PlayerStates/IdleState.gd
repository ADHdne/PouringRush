extends State
class_name IdleState

@export var move_state : State
@export var Jump_state : State



func on_enter():
	if not player.jump_buffer_timer.is_stopped():
		_jump()

func state_process(_delta):
	if not player.direction.x == 0:
		next_state = move_state


## Button Presses
func jump_button_pressed():
	if not player.can_action_pressed:
		return
	
	_jump()
	
func interact_button_pressed():
	if not player.can_action_pressed:
		return
	
	interact()

## Actions

func _jump():
	player.movement_component.jump()
	next_state = Jump_state

func interact():
	if player.carry_component.is_carrying():
		player.carry_component.drop()
	else:
		player.carry_component.pick_up(player.carry_component.zone)
