extends Area2D
class_name TeamZone


@export var team : Team.type


var carrier : Player

@export var carrier_offset : Vector2 = Vector2(0, -100)


func _process(delta: float) -> void:
	if carrier:
		global_position = carrier.global_position + carrier_offset



func pick_up(player : Player):
	
	if player.team != team:
		return
	
	carrier = player

func drop():
	carrier = null
