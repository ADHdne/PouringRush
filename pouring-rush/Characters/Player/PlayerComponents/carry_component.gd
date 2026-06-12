extends Node
class_name CarryComponent


var player : Player

var zone : TeamZone
var carried_zone : TeamZone

func intialize(player : Player):
	self.player = player
	
	zone = player.match_manager.get_camera_zones(player.team)
	

func pick_up(zone : TeamZone):
	
	if not zone:
		return
	
	carried_zone = zone
	zone.pick_up(player)

func drop():
	
	if not carried_zone:
		return
	
	carried_zone.drop()
	carried_zone = null
	

func is_carrying() -> bool:
	return carried_zone != null
