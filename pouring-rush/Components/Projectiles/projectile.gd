extends Area2D
class_name Projectile


@export var data : ProjectileData
@export var lifetime_timer : Timer


var direction : Vector2
var origin : Node


func _ready() -> void:
	lifetime_timer.start(data.lifetime)

func _physics_process(delta: float) -> void:
	global_position += direction * data.speed * delta


func _on_lifetime_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.owner == origin:
		return
	
	if body.has_method("apply_damage"):
		body.apply_damage(data.damage)
		
		body.apply_knockback(direction * data.knockback)
	
	queue_free()
