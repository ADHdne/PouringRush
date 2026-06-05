extends Node
class_name CombatComponent

@export var player : Player
@export var basic_shot_data : AbilityData
@export var special_shot_data : AbilityData


# shot buffering
@export var buffered_ability : AbilityData
@export var shot_buffer : Timer
var shot_buffered : bool = false

var shoot_cooldown := 0.0
@export var fire_rate : float = 0.25 # seconds between shots 
var ability_resource := 100

var ammo : int = 10



func _process(delta):
	# reset the shoot_coooldown after each shot
	shoot_cooldown = max(0, shoot_cooldown - delta)
	
	if can_shoot() and shot_buffered:
		shoot(buffered_ability)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(player.player_actions.attack):
		try_shoot(basic_shot_data)
	if event.is_action_pressed(player.player_actions.special1):
		try_shoot(special_shot_data)

func can_shoot() -> bool:
	return shoot_cooldown <= 0 and player.can_attack


func shoot(data : AbilityData):
	var proj = data.projectile.instantiate()
	
	if player.aim_input() != Vector2(0, 0):
		proj.global_position = player.global_position + (40 * player.aim_direction)
		proj.direction = player.aim_input()
	else:
		if not player.facing_flipped:
			proj.global_position = player.global_position + (Vector2(40, 0) * 1)
			proj.direction.x = 1
		else:
			proj.global_position = player.global_position + (Vector2(40, 0) * -1)
			proj.direction.x = -1
	
	proj.owner = player
	
	get_tree().current_scene.add_child(proj)
	
	# subtract 1 ammo
	data.ammo -= data.projectile_data.ammo_cost
	
	shoot_cooldown = data.cooldown

func try_shoot(data : AbilityData):
	if data.ammo < data.projectile_data.ammo_cost:
		return
	
	if not can_shoot():
		shot_buffered = true
		buffered_ability = data
		shot_buffer.start()
		return
	shoot(data)


func _on_shot_buffer_timer_timeout() -> void:
	shot_buffered = false
