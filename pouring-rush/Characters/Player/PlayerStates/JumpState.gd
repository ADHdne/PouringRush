extends State
class_name JumpState

@export var fall_state : State
@export var idle_state : State
@export var move_state : State


@export_range(0, 1) var deceleration_on_jump_release = 0.300


func on_enter():
	player.sound_effects.jump()


func state_process(_delta):
	if not player.is_on_floor() and player.velocity.y > 0:
		next_state = fall_state
	
	if player.is_on_floor():
		next_state = move_state

func state_input(event : InputEvent):
	if player.can_action_pressed:
		if Input.is_action_just_released(player.input_handler.player_actions.jump) and player.velocity.y < 0:
			jump_peak_reached()
		if event.is_action_pressed(player.input_handler.player_actions.jump) and player.movement_component.jumps_remaining > 0:
			double_jump()
		# for picking up team zone
		if event.is_action_pressed(player.input_handler.player_actions.interact):
			interact()


func jump_peak_reached():
	player.velocity.y *= deceleration_on_jump_release

func double_jump():
	player.movement_component.jumps_remaining -= 1
	# the physical jump
	player.velocity.y = player.character_data.double_jump_power


func interact():
	if player.carry_component.is_carrying():
		player.carry_component.drop()
	else:
		player.carry_component.pick_up(player.carry_component.zone)
