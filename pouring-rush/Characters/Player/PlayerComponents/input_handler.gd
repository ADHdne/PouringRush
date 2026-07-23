extends Node
class_name InputHandler




@export var player_actions : PlayerActions

@export var player : Player
@export var state_machine : CharacterStateMachine
@export var combat_component : CombatComponent

var controller_id : int = -1


var movement_direction : Vector2 = Vector2.ZERO
var aim_direction : Vector2 = Vector2.RIGHT

# deadzone for sticks
const DEADZONE : float = 0.2


func set_up(device_id : int, player : Player, state_machine : CharacterStateMachine, combat_component : CombatComponent):
	controller_id = device_id
	self.player = player
	self.state_machine = state_machine
	self.combat_component = combat_component



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
	
	
	# 2. HANDLE STICK AXIS MOVEMENTS
	if event is InputEventJoypadMotion:
		# --- LEFT STICK (Movement Tracking) ---
		if event.axis == JOY_AXIS_LEFT_X or event.axis == JOY_AXIS_LEFT_Y:
			# Get current updated values directly from the hardware
			var lx := Input.get_joy_axis(controller_id, JOY_AXIS_LEFT_X)
			var ly := Input.get_joy_axis(controller_id, JOY_AXIS_LEFT_Y)
			var raw_left := Vector2(lx, ly)
			
			# Save vector if pushed past deadzone, otherwise reset to zero
			movement_direction = raw_left if raw_left.length() > DEADZONE else Vector2.ZERO

		# --- RIGHT STICK (Aim Tracking) ---
		if event.axis == JOY_AXIS_RIGHT_X or event.axis == JOY_AXIS_RIGHT_Y:
			var rx := Input.get_joy_axis(controller_id, JOY_AXIS_RIGHT_X)
			var ry := Input.get_joy_axis(controller_id, JOY_AXIS_RIGHT_Y)
			var raw_right := Vector2(rx, ry)
			
			# Only update aim direction when actively holding/flicking the stick
			aim_direction = raw_right if raw_right.length() > DEADZONE else Vector2.ZERO
