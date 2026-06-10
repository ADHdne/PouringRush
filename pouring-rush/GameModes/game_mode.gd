extends Node
class_name GameMode


var match_manager : MatchManager
var arena
var players : Array[Player]



func _process(delta: float) -> void:
	
	check_ko()


# gets called in match manager
func initialize(match_manager : MatchManager):
	self.match_manager = match_manager
	self.players = match_manager.players


func start_match():
	pass

func end_match():
	print("Match ended")


func check_ko():
	for p in match_manager.players:
		
		var zone = match_manager.get_camera_zones(p.team)
		
		if not zone.contains_point(p.global_position):
			on_player_ko(p)

func on_player_ko(player : Player):
	print("player ", player, " died")

func check_win_condition():
	pass
