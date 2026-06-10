extends Node
class_name MatchManager



var match_config = MatchConfig

var arena : Arena
var game_mode : GameMode

var players : Array[Player] = []

var players_root : Node2D

@export var player_scene : PackedScene


# this gets called from match_scene
func initialize(match_config : MatchConfig, arena : Arena, game_mode : GameMode, players_root : Node2D):
	
	self.match_config = match_config
	self.arena = arena
	self.game_mode = game_mode
	self.players_root = players_root
	
	spawn_players()
	
	game_mode.initialize(self)
	game_mode.start_match()


func start_match():
	pass

func spawn_players():
	# clearing players array just in case
	players.clear()
	
	for i in range(match_config.players.size()):
		var config : PlayerConfig = match_config.players[i]
		
		var spawn_point : Node2D = arena.get_spawn_point(i)
		
		var player : Player = spawn_player(config, spawn_point)
		
		players.append(player)

func spawn_player(config : PlayerConfig, spawn_point : Node2D):
	var p : Player = player_scene.instantiate()
	
	players_root.add_child(p)
	
	# inject runtime identity
	p.initialize(config.character_data, self)
	
	# assigning match spesific state
	p.team = config.team
	
	p.global_position = spawn_point.global_position

func on_player_ko(player : Player):
	respawn_player(player)

func respawn_player(player):
	# respawns player
	# this need to reflect what team the player is on
	player.global_position = arena.get_spawn_point(0).global_position
	
	player.reset_for_respawn() # need to make this a function in player


func _physics_process(delta: float) -> void:
	
	for p in players:
		if not p.team_camera.overlaps_point(p.global_position):
			print("would KO")

func end_match():
	pass
