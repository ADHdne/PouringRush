extends Node
class_name KOComponent

@export var player : Player


@export var wall_ko_speed : float = 1200
@export var ceiling_ko_speed : float = 1000


func check_impact():
	
	var speed = player.velocity.length()
	
	if speed >= ceiling_ko_speed - 300:
		KO()
	

func KO():
	player.queue_free()
