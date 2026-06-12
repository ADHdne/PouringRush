extends Node
class_name CarryComponent


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


func drop():
	
	if not carried_zone:
		return
	
	carried_zone.drop()
	carried_zone = null
	

func is_carrying() -> bool:
	return carried_zone != null
