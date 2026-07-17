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

func state_input(event : InputEvent):
	if player.can_action_pressed:
		if player.input_handler.check_controller(player.input_handler.player_actions.jump):
			_jump()
		# for picking up team zone
		if event.is_action_pressed(player.input_handler.player_actions.interact):
			if player.carry_component.is_carrying():
				player.carry_component.drop()
			else:
				player.carry_component.pick_up(player.carry_component.zone)

func _jump():
	player.movement_component.jump()
	next_state = Jump_state
