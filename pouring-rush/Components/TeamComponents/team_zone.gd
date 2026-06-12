extends Area2D
class_name TeamZone


@export var team : Team.type


var carrier : Player

@export var carrier_offset : Vector2 = Vector2(0, -40)

@export var pickup_range : float = 50

@export var grav : float = 1000.0


func _process(delta: float) -> void:
	
	# following player if carried
	if carrier:
		global_position = carrier.global_position + carrier_offset


func can_be_picked_up(player : Player) -> bool:
	
	if player.team!= team:
		return false
	
	if carrier != null:
		return false

	return global_position.distance_to(player.global_position) < pickup_range

func try_pick_up(player : Player) -> bool:
	
	if not can_be_picked_up(player):
		return false
	
	carrier = player
	return true

func drop():
	carrier = null
