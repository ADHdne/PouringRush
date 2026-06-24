extends SafeZoneArea
class_name TeamBase


@export var area_visual : ColorRect
@export var collision_shape : CollisionShape2D

func _ready() -> void:
	setup_size()




func setup_size():
	
	area_visual.size = collision_shape.shape.get_rect().size
	area_visual.position = -collision_shape.shape.size / 2.0
