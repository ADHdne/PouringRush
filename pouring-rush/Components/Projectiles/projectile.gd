extends Area2D
class_name Projectile


@export var data : ProjectileData
@export var lifetime_timer : Timer

# reference to children
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


var direction : Vector2
var velocity : Vector2

var origin : Player


func _ready() -> void:
	collision_shape.shape.radius = data.radius
	sprite.texture = data.texture
	sprite.scale = data.sprite_size
	sprite.rotation_degrees = data.sprite_rotation
	lifetime_timer.start(data.lifetime)

func _physics_process(delta: float) -> void:
	# apply gravity
	velocity.y += data.gravity * delta
	
	
	# basic movement
	global_position += velocity * delta
	
	
	# rotating with gravity pull
	if velocity.length() > 0.1:
		rotation = velocity.angle()



func _on_lifetime_timer_timeout() -> void:
	queue_free()


func disolve():
	# take a way 1 from amount of piercing and if 0 then queue free
	# if piercing < 0 then it keeps going through without getting queued free (only by lifetime)
	if data.pierces > 0:
		data.pierces -= 1
	elif data.pierces == 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ground"):
		disolve() # removes or subtract from pierce


func _on_area_entered(area: Area2D) -> void:
	# duplicating hit_data to make it unique
	var _hit_data = data.hit_data.duplicate()
	# adding its direction
	_hit_data.direction = velocity.normalized()
	
	# make sure you dont shoot your self
	if area.owner == origin:
		return
	
	
	if area.has_method("recieve_hit"):
		area.recieve_hit(_hit_data, origin)
	
	disolve() # removes or subtract from pierce
