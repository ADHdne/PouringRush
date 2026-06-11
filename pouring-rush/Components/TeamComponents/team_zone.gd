extends Area2D
class_name TeamZone


@export var team : Team.type


var carrier : Player


func pick_up(player : Player):
	carrier = player

func drop():
	carrier = null
