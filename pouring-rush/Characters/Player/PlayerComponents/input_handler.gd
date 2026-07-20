extends Node
class_name InputHandler




@export var player_actions : PlayerActions

@export var player : Player
@export var state_machine : CharacterStateMachine
@export var combat_component : CombatComponent

var controller_id : int = -1






func set_up(device_id : int, player : Player, state_machine : CharacterStateMachine, combat_component : CombatComponent):
	controller_id = device_id
	self.player = player
	self.state_machine = state_machine
	self.combat_component = combat_component

func _physics_process(delta: float) -> void:
	
	if player != null:
		if player.can_action_pressed:
			input()


func check_controller(action : StringName) -> bool:
	for event in InputMap.action_get_events(action):
		if event.device == controller_id:
			return Input.is_action_pressed(action)
	return false

func _unhandled_input(event: InputEvent) -> void:
	if event.device != controller_id:
		return
	
	# combat buttons
	if not player.carry_component.is_carrying() and player.can_action_pressed and player.can_attack:
		if event.is_action_pressed(player_actions.attack):
			combat_component.attack_button_pressed()
		if event.is_action_pressed(player_actions.special_1):
			combat_component.special_1_button_pressed()
		if event.is_action_pressed(player_actions.special_2):
			combat_component.special_2_button_pressed()
		if event.is_action_pressed(player_actions.utility):
			combat_component.utility_button_pressed()
		if event.is_action_pressed(player_actions.reload):
			combat_component.reload_button_pressed()

	
	# state buttons (current state)
	if event.is_action_pressed(player_actions.jump):
		if state_machine.current_state.has_method("jump_button_pressed"):
			state_machine.current_state.jump_button_pressed()
	if event.is_action_released(player_actions.jump):
		if state_machine.current_state.has_method("jump_button_released"):
			state_machine.current_state.jump_button_released()
	
	if event.is_action_pressed(player_actions.block):
		if state_machine.current_state.has_method("tech_button_pressed"):
			state_machine.current_state.tech_button_pressed()
	
	if event.is_action_pressed(player_actions.interact):
		if state_machine.current_state.has_method("interact_button_pressed"):
			state_machine.current_state.interact_button_pressed()

func input() -> Vector2:
	var input : Input
	
	player.direction = Input.get_vector(player_actions.move_left, player_actions.move_right, player_actions.move_up, player_actions.move_down)
	player.direction = player.direction.normalized()
	return player.direction

func aim_input() -> Vector2:
	player.aim_direction = Input.get_vector(player_actions.aim_left, player_actions.aim_right, player_actions.aim_up, player_actions.aim_down)
	player.aim_direction = player.aim_direction.normalized()
	return player.aim_direction
