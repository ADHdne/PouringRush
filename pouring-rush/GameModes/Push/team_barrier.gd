extends PushObject
class_name PushBarrier


@export var sprite : Sprite2D

var team : Team.type

var start_progress : float



func set_color():
	var color : Color
	
	match team:
		Team.type.RED:
			color = Color(0.7,0.2,0.2)
		Team.type.BLUE:
			color = Color(0.2,0.2,0.7)
	
	sprite.modulate = color
