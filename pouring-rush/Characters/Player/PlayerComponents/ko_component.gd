extends Node
class_name KOComponent

@export var player : Player

@export var ko_state : KOState

@export var wall_ko_speed : float = 1000
@export var ceiling_ko_speed : float = 800
@export var floor_ko_speed : float = 1200

@export var collision_speed : float

# Getting reference to color rect for debugging !!!!!!!!!!!!!!!!!!!!!!
@export var color : ColorRect

var threshold : float


func get_speed() -> float:
	var speed = player.velocity.length()
	return speed

# checks if player is starting close to wall/ceiling, from knockback component
func check_immedate_impact():
	if player.ceiling_collision_check.has_overlapping_bodies():
		check_impact("Ceiling")
	elif player.wall_collision_check.has_overlapping_bodies():
		check_impact("Wall")

func check_killing_speed():
	# gives colors as hints to if you will die if hitting a wall
	if get_speed() >= wall_ko_speed:
		color.color = Color(1.0, 0.0, 0.0) # something get red
	elif get_speed() >= ceiling_ko_speed:
		color.color = Color(0.0, 0.0, 1.0) # something gets blue
	else:
		color.color = Color(0.486, 0.839, 0.431)

# tumble state calles this through player
func check_impact(surface : String):
	if surface == "Ceiling":
		if get_speed() >= ceiling_ko_speed:
			KO()
	if surface == "Wall":
		if get_speed() >= wall_ko_speed:
			KO()

func KO():
	if ko_state != null:
		player.state_machine.on_state_interupt_state(ko_state)
	else:
		print("no ko state")
