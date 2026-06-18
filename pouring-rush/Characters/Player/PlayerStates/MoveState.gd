extends State
class_name MoveState


# state reference
@export var jump_state : State
@export var idle_state : State
@export var fall_state : State


func on_enter():
	if not player.jump_buffer_timer.is_stopped():
		_jump()

func state_process(_delta):
	if player.is_on_floor() and player.direction.x == 0:
		next_state = idle_state
	if not player.is_on_floor():
		next_state = fall_state


func state_input(event : InputEvent):
	if player.can_action_pressed:
		if event.is_action_pressed(player.player_actions.jump):
			_jump()
		# for picking up team zone
		if event.is_action_pressed(player.player_actions.interact):
			if player.carry_component.is_carrying():
				player.carry_component.drop()
			else:
				player.carry_component.pick_up(player.carry_component.zone)


func _jump():
	player.movement_component.jump()
	next_state = jump_state
