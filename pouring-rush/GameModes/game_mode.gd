extends Node
class_name GameMode


@onready var overtime_timer: Timer = $OvertimeTimer


var match_manager : MatchManager
var arena
var players : Array[Player]

var match_time : float = 600
var overtime : bool = false

var ko_check_timer := 0.0


var core_in_base : ={
	Team.type.RED: false,
	Team.type.BLUE : false
}

var core_base_time := {
	Team.type.RED : 0.0,
	Team.type.BLUE : 0.0
}


const RESPAWN_TIME : = 7

var red_team_wins : bool = false
var blue_team_wins : bool = false

func _ready() -> void:
	SignalBus.team_core_entered_base.connect(on_core_entered)
	SignalBus.team_core_exited_base.connect(on_core_exited)


func _physics_process(delta: float) -> void:
	
	if not match_manager.match_in_progress:
		return
	
	
	ko_check_timer += delta


	for team in core_in_base.keys():
		if core_in_base[team]:
			core_base_time[team] += delta
			
			if core_base_time[team] >= RESPAWN_TIME:
				match_manager.respawn_team(team)
				core_base_time[team] = 0.0


	if ko_check_timer > 0.1:
		ko_check_timer = 0
		check_ko()


# gets called in match manager
func initialize(match_manager : MatchManager):
	self.match_manager = match_manager
	self.players = match_manager.players




func start_match():
	print("GameMode: Match started")




func check_ko():
	for p in match_manager.players:
		
		if not p.alive:
			return
		
		var safe = false
		for zone in match_manager.get_safe_zones(p.team):
			if p.player_index == 0:
				print("player: ", p.player_index, " , zones: ", zone)
			if zone.overlaps_area(p.hurtbox):
				safe = true
				break

		if not safe:
			on_player_ko(p)

func on_player_ko(player : Player):
	player.ko()
	match_manager.on_player_ko(player)
	print("player ", player, " died")

func update_respawn_logic(team: Team.type, delta: float):

	if not core_in_base[team]:
		core_base_time[team] = 0.0
		return

	core_base_time[team] += delta

	if core_base_time[team] >= RESPAWN_TIME:
		match_manager.respawn_team(team)
		core_base_time[team] = 0.0


func on_core_entered(team : Team.type):
	core_in_base[team] = true
	core_base_time[team] = 0.0

func on_core_exited(team : Team.type):
	core_in_base[team] = false
	core_base_time[team] = 0.0

func match_timer_timeout():
	pass

func determine_winner_on_timeout():
	pass

func check_win_condition():
	pass


func _on_overtime_timer_timeout() -> void:
	pass # Replace with function body.


func end_match(winner : String):
	
	# gives winning team to game manager (that is not being used)
	GameManager.winning_team = winner
	
	match_manager.view_system.red_match_ui.end_game(winner)
	match_manager.view_system.blue_match_ui.end_game(winner)
