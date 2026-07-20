extends State
class_name MoveState


# state reference
@export var jump_state : State
@export var idle_state : State
@export var fall_state : State

@export var coyote_timer : Timer


func on_enter():
	if not player.jump_buffer_timer.is_stopped():
		_jump()
	
	player.footstep_timer.start(0.1)

func state_process(delta):
	
	# playing footstep sound
	if player.footstep_timer.time_left <= 0:
		player.sound_effects.run()
		player.footstep_timer.start(0.2)

	
	if player.is_on_floor() and player.direction.x == 0:
		next_state = idle_state
	if not player.is_on_floor():
		next_state = fall_state
	
	
	player.rotate_gear(delta)


# Button Presses
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
	next_state = jump_state

func interact():
	if player.carry_component.is_carrying():
		player.carry_component.drop()
	else:
		player.carry_component.pick_up(player.carry_component.zone)


func on_exit():
	player.footstep_timer.stop()
	
	if next_state == fall_state:
		coyote_timer.start()
