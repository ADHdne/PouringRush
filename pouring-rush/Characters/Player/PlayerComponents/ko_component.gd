extends Node
class_name KOComponent

@export var player : Player


@export var wall_ko_speed : float = 1000
@export var ceiling_ko_speed : float = 800


func check_impact():
	
	var speed = player.velocity.length()
	
	if speed >= ceiling_ko_speed:
		KO()
	

func KO():
	player.queue_free()
