extends Node
class_name KOComponent

@export var player : Player


@export var wall_ko_speed : float = 1000
@export var ceiling_ko_speed : float = 800


func get_speed() -> float:
	var speed = player.velocity.length()
	return speed

func check_killing_speed():
	# gives colors as hints to if you will die if hitting a wall
	if get_speed() >= wall_ko_speed:
		print("red") # something get red
	elif get_speed() >= ceiling_ko_speed:
		print("blue") # something gets blue

# tumble state calles this through player
func check_impact():
	print("speed: ", get_speed(), ", ceiling ko speed: ", ceiling_ko_speed)
	if player.ko_collision_check.collision_speed >= ceiling_ko_speed:
		KO()

func KO():
	player.queue_free()
