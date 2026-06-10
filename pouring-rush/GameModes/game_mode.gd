extends Node
class_name GameMode


var match_manager : MatchManager
var arena
var players : Array[Player]

var match_in_progress = false

func _process(delta: float) -> void:
	if match_in_progress == true:
		check_ko()


# gets called in match manager
func initialize(match_manager : MatchManager):
	self.match_manager = match_manager
	self.players = match_manager.players


func start_match():
	match_in_progress = true

func end_match():
	match_in_progress = false
	print("match ended")


func check_ko():
	
	for p in match_manager.players:
		print("Hey")
		var zone = match_manager.get_camera_zones(p.team)
		
		if not zone.overlaps_body(p):
			on_player_ko(p)

func on_player_ko(player : Player):
	print("player ", player, " died")

func check_win_condition():
	pass
