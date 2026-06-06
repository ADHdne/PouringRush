extends State
class_name JumpState

@export var fall_state : State
@export var idle_state : State
@export var move_state : State


@export_range(0, 1) var deceleration_on_jump_release = 0.300


func on_enter():
	pass


func state_process(_delta):
	if not player.is_on_floor() and player.velocity.y > 0:
		next_state = fall_state

func state_input(event : InputEvent):
	if player.can_action_pressed:
		if Input.is_action_just_released(player.player_actions.jump) and player.velocity.y < 0:
			player.velocity.y *= deceleration_on_jump_release
		if event.is_action_pressed(player.player_actions.jump) and player.movement.jumps_remaining > 0:
			double_jump()

func double_jump():
	player.movement.jumps_remaining -= 1
	# the physical jump
	player.velocity.y = player.properties.double_jump_power
