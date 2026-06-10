extends Node
class_name MatchManager


var arena : Arena
var game_mode : GameMode

var players : Array[Player] = []

var player_scene : PackedScene


# this gets called from match_scene
func initialize(p_arena : Arena, p_game_mode : GameMode, players_root : Node2D):
	arena = p_arena
	game_mode = p_game_mode
	
	spawn_players(players_root)


func start_match():
	pass

func spawn_players(players_root):
	var p1 = player_scene.instansiate()
	var p2 = player_scene.instansiate()
	
	players_root.add_child(p1)
	players_root.add_child(p2)
	
	players = [p1, p2]
	
	for p in players:
		p.initialize(, self)
	
	# assign global position after initializing
	p1.global_position = arena.get_spawn_point(0).global_position
	p2.global_position = arena.get_spawn_point(1).global_position

func on_player_ko(player : Player):
	respawn_player(player)

func respawn_player(player):
	# respawns player
	# this need to reflect what team the player is on
	player.global_position = arena.get_spawn_point(0).global_position
	
	player.reset_for_respawn() # need to make this a function in player


func end_match():
	pass
