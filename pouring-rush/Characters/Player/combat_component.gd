extends Node
class_name CombatComponent

@export var player : Player
@export var projectile : PackedScene
@export var projectile_data : ProjectileData


var shoot_cooldown := 0.0
@export var fire_rate : float = 0.25
var ability_resource := 100

var ammo : int = 10



func _process(delta):
	shoot_cooldown = max(0, shoot_cooldown - delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Attack"):
		try_shoot()

func can_shoot() -> bool:
	return shoot_cooldown <= 0 and player.can_attack


func shoot():
	
	var proj = projectile.instantiate()
	
	proj.global_position = player.global_position
	proj.direction = player.aim_input()
	proj.owner = player
	
	get_tree().current_scene.add_child(proj)
	
	shoot_cooldown = fire_rate

func try_shoot():
	if ammo < projectile_data.ammo_cost:
		return
	
	ammo -= projectile_data.ammo_cost
	shoot()
