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

var shoot_cooldown := 0.0

## basic shot

func initialize(character_data : CharacterData):
	basic_shot_data = create_state(character_data.basic_shot)
	special_shot_data = create_state(character_data.special_1)
	#special_2_data = create_state(character_data.special_2)
	#utility_data = create_state(character_data.utility)
	

func _process(delta):
	# reset the shoot_coooldown after each shot
	shoot_cooldown = max(0, shoot_cooldown - delta)
	
	if can_shoot() and shot_buffered:
		shoot(buffered_ability)

func _input(event: InputEvent) -> void:
	if not player.carry_component.is_carrying():
		if event.is_action_pressed(player.player_actions.attack):
			try_shoot(basic_shot_data)
		if event.is_action_pressed(player.player_actions.special_1):
			try_shoot(special_shot_data)
		if event.is_action_pressed(player.player_actions.special_2):
			try_shoot(special_2_data)
		if event.is_action_pressed(player.player_actions.reload):
			begin_reload()



## shooting logic
func can_shoot() -> bool:
	return shoot_cooldown <= 0 and player.can_attack


func shoot(data : AbilityState):
	
	var proj = data.ability_data.projectile_scene.instantiate()
	
	# get direction
	var direction = player.aim_input()
	
	# add the right data for the projectile
	proj.data = data.ability_data.projectile_data
	
	if player.aim_input() != Vector2(0, 0):
		proj.global_position = player.global_position + (15 * player.aim_direction)
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


func try_shoot(data : AbilityState):
	if data.current_ammo < data.ability_data.projectile_data.ammo_cost:
		return
	
	if not can_shoot():
		shot_buffered = true
		buffered_ability = data
		shot_buffer.start()
		return
	shoot(data)


func _on_shot_buffer_timer_timeout() -> void:
	shot_buffered = false

func create_state(data : AbilityData) -> AbilityState:
	
	var state = AbilityState.new()
	
	state.ability_data = data
	state.current_ammo = data.max_ammo
	state.cooldown_remaining = 0.0
	state.is_reloading = false
	
	return state

## reload logic
func begin_reload():
	pass
