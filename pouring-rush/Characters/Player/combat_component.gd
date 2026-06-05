extends Node
class_name CombatComponent

@export var player : Player
@export var projectile : PackedScene
@export var projectile_data : ProjectileData

# shot buffering
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
		shoot()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Attack"):
		try_shoot()

func can_shoot() -> bool:
	return shoot_cooldown <= 0 and player.can_attack


func shoot():
	var proj = projectile.instantiate()
	
	if player.aim_input() != Vector2(0, 0):
		proj.global_position = player.global_position + (40 * player.aim_direction)
		proj.direction = player.aim_input()
	else:
		proj.global_position = player.global_position + Vector2(40, 0) # skuddet står bare stille om det ikke er noen retning input.
	
	proj.owner = player
	
	get_tree().current_scene.add_child(proj)
	
	shoot_cooldown = fire_rate

func try_shoot():
	if ammo < projectile_data.ammo_cost:
		return
	
	if not can_shoot():
		shot_buffered = true
		shot_buffer.start()
		return
	ammo -= projectile_data.ammo_cost
	shoot()


func _on_shot_buffer_timer_timeout() -> void:
	shot_buffered = false
