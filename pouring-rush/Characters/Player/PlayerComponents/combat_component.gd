extends Node
class_name CombatComponent

@export var player : Player
var basic_shot_data : AbilityState
var special_shot_data : AbilityState
var special_2_data : AbilityState
var utility_data : AbilityState


# shot buffering
var buffered_ability : AbilityState
@export var shot_buffer : Timer
var shot_buffered : bool = false

# sound
@export var generic_shot_sound : AudioStream
var generic_shot_volume : float = -10
@export var generic_reload_sound : AudioStream


var shoot_cooldown := 0.0

## basic shot

func initialize(character_data : CharacterData):
	create_states(character_data)

func _process(delta):
	# reset the shoot_coooldown after each shot
	shoot_cooldown = max(0, shoot_cooldown - delta)
	
	# ability cooldown
	for ability in [special_shot_data, special_2_data, utility_data]:
		if ability == null:
			return
		
		if ability.cooldown_remaining > 0:
			ability.cooldown_remaining = max(0.0, ability.cooldown_remaining - delta)
	
	if shot_buffered:
		if can_shoot(buffered_ability):
			try_use_ability(buffered_ability)

func _input(event: InputEvent) -> void:
	if not player.carry_component.is_carrying() and player.can_action_pressed and player.can_attack:
		if event.is_action_pressed(player.player_actions.attack):
			try_use_ability(basic_shot_data)
		if event.is_action_pressed(player.player_actions.special_1):
			try_use_ability(special_shot_data)
		if event.is_action_pressed(player.player_actions.special_2):
			try_use_ability(special_2_data)
		if event.is_action_pressed(player.player_actions.utility):
			try_use_ability(utility_data)
		if event.is_action_pressed(player.player_actions.reload):
			request_reload()


func create_states(data : CharacterData):
	basic_shot_data = create_state(data.basic_shot)
	special_shot_data = create_state(data.special_1)
	special_2_data = create_state(data.special_2)
	utility_data = create_state(data.utility)

func create_state(data : AbilityData) -> AbilityState:
	
	var state = AbilityState.new()
	
	state.ability_data = data
	state.current_ammo = data.max_ammo
	state.cooldown_remaining = 0.0
	state.is_reloading = false
	
	return state

func try_use_ability(data: AbilityState):
	# check for different things that you might want to buffer
	if not can_shoot(data):
		shot_buffered = true
		buffered_ability = data
		shot_buffer.start()
		return

	match data.ability_data.ability_type:

		AbilityData.AbilityType.PROJECTILE:
			try_shoot(data)

		AbilityData.AbilityType.UTILITY:
			use_utility(data)
	
	data.cooldown_remaining = data.ability_data.ability_cooldown

## shooting logic
func can_shoot(data : AbilityState) -> bool:
	return shoot_cooldown <= 0 and player.can_attack and player.can_action_pressed and data.cooldown_remaining <= 0


# Checks ammo
func try_shoot(data : AbilityState):
	if data.current_ammo < data.ability_data.projectile_data.ammo_cost:
		return
	
	shoot(data)


func shoot(data : AbilityState):
	
	var proj = data.ability_data.projectile_scene.instantiate()
	
	# get direction
	var direction = player.aim_input()
	
	# add the right data for the projectile
	proj.data = data.ability_data.projectile_data
	
	if player.aim_input() != Vector2(0, 0):
		proj.global_position = player.global_position + Vector2(0, -10) + (15 * player.aim_direction)
		proj.velocity = direction.normalized() * data.ability_data.projectile_data.speed
	else:
		if not player.facing_flipped:
			proj.global_position = player.global_position + (Vector2(15, 0) * 1)
			proj.velocity = Vector2(1,0).normalized() * data.ability_data.projectile_data.speed
		else:
			proj.global_position = player.global_position + (Vector2(15, 0) * -1)
			proj.velocity = Vector2(-1,0).normalized() * data.ability_data.projectile_data.speed
	
	proj.origin = player
	
	get_tree().current_scene.add_child(proj)
	
	# subtract 1 ammo
	data.current_ammo -= data.ability_data.projectile_data.ammo_cost
	
	shoot_cooldown = data.ability_data.cooldown
	
	if data.ability_data.shoot_shound != null:
		player.sound_effects.shoot(data.ability_data.shoot_shound, data.ability_data.shoot_sound_volume)
	else:
		player.sound_effects.shoot(generic_shot_sound, generic_shot_volume)


func use_utility(data : AbilityState):
	match data.ability_data.utility_type:
		
		AbilityData.UtilityType.DASH:
			dash(data)
		
		AbilityData.UtilityType.TELEPORT:
			pass
		
		AbilityData.UtilityType.GRAPPLE:
			pass

func dash(data: AbilityState):

	var ability := data.ability_data

	player.movement_component.start_dash(
		player.direction,
		ability.dash_speed,
		ability.dash_duration
	)
	
	# play dash sound
	player.sound_effects.dash()

## reload logic
func request_reload():
	player.state_machine.request_reload()

func reset_for_spawn(data : CharacterData):
	clear_states()
	create_states(data)

func clear_states():
	basic_shot_data = null
	special_shot_data = null
	special_2_data = null
	utility_data = null


func _on_shot_buffer_timer_timeout() -> void:
	shot_buffered = false

func _on_reload_timer_timeout() -> void:
	basic_shot_data.current_ammo = basic_shot_data.ability_data.max_ammo
