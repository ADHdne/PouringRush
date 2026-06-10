extends Node
class_name GameMode


var match_manager : MatchManager
var arena
var players : Array[Player]


func initialize(match_manager : MatchManager):
	self.match_manager = match_manager
	self.players = match_manager.players


func start_match():
	pass

func end_match():
	print("Match ended")

func on_player_ko(player : Player):
	pass

func check_win_condition():
	pass
