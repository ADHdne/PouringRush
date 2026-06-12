extends Node
class_name CarryComponent


@export var pickup_state : State
@export var put_down_state : State

var player : Player

var zone : TeamZone
var carried_zone : TeamZone

func intialize(player : Player):
	self.player = player
	


func pick_up(zone : TeamZone):

	if carried_zone:
		return
	
	if zone.try_pick_up(player):
		carried_zone = zone
		# switching states after picking up so cant shoot
		player.state_machine.on_state_interupt_state(pickup_state)


func drop():
	
	if not carried_zone:
		return
	
	# switching states befor dropping so cant shoot
	player.state_machine.on_state_interupt_state(put_down_state)
	carried_zone.drop()
	carried_zone = null
	

func is_carrying() -> bool:
	return carried_zone != null
