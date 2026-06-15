extends Node
class_name GameMode


var match_manager : MatchManager
var arena
var players : Array[Player]

var match_in_progress = false
var ko_check_timer := 0.0

func _process(delta: float) -> void:

	ko_check_timer += delta


	if match_in_progress == true:
		if ko_check_timer > 0.1:
			ko_check_timer = 0
			check_ko()


# gets called in match manager
func initialize(match_manager : MatchManager):
	self.match_manager = match_manager
	self.players = match_manager.players
	


func start_match():
	match_in_progress = true
	print("GameMode: Match started")

func end_match():
	match_in_progress = false
	print("GameMode: Match ended")


func check_ko():
	for p in match_manager.players:
		var safe = false
		print("player collision: ", p.hurtbox.get_overlapping_areas())
		for zone in match_manager.get_safe_zones(p.team):
			print("zone overlapping: ", zone.get_overlapping_areas())
			if zone.overlaps_area(p.hurtbox):
				safe = true
				break

		if not safe:
			on_player_ko(p)

func on_player_ko(player : Player):
	player.ko()
	match_manager.on_player_ko(player)
	print("player ", player, " died")

func check_win_condition():
	pass
