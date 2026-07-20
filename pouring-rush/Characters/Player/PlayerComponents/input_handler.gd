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
	
	if event.is_action_pressed(player_actions.tech):
		if state_machine.current_state.has_method("tech_button_pressed"):
			state_machine.current_state.tech_button_pressed()
	
	if event.is_action_pressed(player_actions.interact):
		if state_machine.current_state.has_method("interact_button_pressed"):
			state_machine.current_state.interact_button_pressed()
