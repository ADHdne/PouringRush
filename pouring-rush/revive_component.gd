extends Node
class_name ReviveComponent

@export var revive_time := 2.5

@export var revive_state : State

var _owner : Player
var area : ReviveArea

func initialize(player : Player, revive_area : ReviveArea):

	_owner = player
	area = revive_area


func try_revive() -> bool:
	
	var target: Player = null
	var closest_distance := INF

	for player in area.candidates:
		if not player.can_be_revived(owner):
			continue
		
		print("Trying to revive player: ", player, " player pos: ", player.global_position)
		
		var distance := _owner.global_position.distance_squared_to(player.global_position)

		if distance < closest_distance:
			closest_distance = distance
			target = player

	if target == null:
		return false
	revive(target)
	return true


func revive(player : Player):

	if not is_instance_valid(player):
		return

	if not player.alive:
		_owner.state_machine.on_state_interupt_state(revive_state)
		player.revive()
