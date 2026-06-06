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
	if body.is_in_group("Ground"):
		return


func _on_area_entered(area: Area2D) -> void:
	
	# duplicating hit_data
	var _hit_data = data.hit_data.duplicate()
	# adding its direction
	_hit_data.direction = direction
	
	if area.owner == origin:
		return
	
	
	if area.has_method("recieve_hit"):
		area.recieve_hit(_hit_data)
	if data.pierces > 0:
		data.pierces -= 1
	elif data.pierces == 0:
		queue_free()
