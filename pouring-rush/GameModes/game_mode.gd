extends Node
class_name GameMode


var match_manager : MatchManager
var arena
var players : Array[Player]

var match_in_progress = false
var ko_check_timer := 0.0

var red_respawn_charge : float = 0
var blue_respawn_charge : float = 0

const RESPAWN_TIME : = 1

func _process(delta: float) -> void:

	update_respawn_charge(Team.type.RED, delta)
	update_respawn_charge(Team.type.BLUE, delta)
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
		for zone in match_manager.get_safe_zones(p.team):
			
			if zone.overlaps_area(p.hurtbox):
				safe = true
				break

		if not safe:
			on_player_ko(p)

func on_player_ko(player : Player):
	player.ko()
	match_manager.on_player_ko(player)
	print("player ", player, " died")

func update_respawn_charge(team: Team.type, delta: float):

	var zone = match_manager.get_team_zones(team)
	var base = match_manager.get_base_zones(team)

	if zone == null:
		return

	if base.overlaps_area(zone):
		add_respawn_charge(team, delta)
	else:
		reset_respawn_charge(team)

func add_respawn_charge(team: Team.type, delta: float):
	
	match team:

		Team.type.RED:
			red_respawn_charge += delta

			if red_respawn_charge >= RESPAWN_TIME:
				respawn_dead_players(team)
				red_respawn_charge = 0.0

		Team.type.BLUE:
			blue_respawn_charge += delta

			if blue_respawn_charge >= RESPAWN_TIME:
				respawn_dead_players(team)
				blue_respawn_charge = 0.0

func reset_respawn_charge(team: Team.type):
	match team:
		Team.type.RED:
			red_respawn_charge = 0.0

		Team.type.BLUE:
			blue_respawn_charge = 0.0

func respawn_dead_players(team: Team.type):
	
	for player in match_manager.players:

		if player.team != team:
			continue

		if player.alive:
			continue
		match_manager.respawn_player(player)

func check_win_condition():
	pass
