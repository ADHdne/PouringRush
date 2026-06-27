extends Area2D
class_name ControlZone




@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var area_visual: ColorRect = $CollisionShape2D/ColorRect




func _ready() -> void:
	setup_size()


func setup_size():
	
	area_visual.size = collision_shape.shape.get_rect().size
	area_visual.position = -collision_shape.shape.size / 2.0


func deactivate():
	visible = false
