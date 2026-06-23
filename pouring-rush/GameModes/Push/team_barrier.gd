extends PushObject
class_name PushBarrier


@export var sprite : Sprite2D

var team : Team.type

var start_progress : float

func _ready() -> void:
	start_progress = progress
	

func set_color():
	var color : Color
	
	match team:
		Team.type.RED:
			color = Color(1,0,0)
		Team.type.BLUE:
			color = Color(0,0,1)
	
	sprite.modulate = color
