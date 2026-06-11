extends Camera2D
class_name TeamCamera


var target_zone : TeamZone


func _process(delta: float) -> void:
	
	if target_zone == null:
		return
	
	global_position = target_zone.global_position


func set_world(world : Node):
	
	
	pass
