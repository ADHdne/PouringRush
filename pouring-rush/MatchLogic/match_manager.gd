extends Node
class_name MatchManager



@export var player_scene : PackedScene
@export var team_zone_scene: PackedScene

var match_config = MatchConfig

var view_system : ViewSystem

var arena : Arena
var game_mode : GameMode

var players : Array[Player] = []

var players_root : Node2D

var red_zone : TeamZone
var blue_zone : TeamZone


# this gets called from match_scene
func initialize(match_config : MatchConfig, world : World, view_system : ViewSystem):
	
	self.match_config = match_config
	self.players_root = world.players_root
	self.view_system = view_system
	
	load_arena(world.arena_root)
	spawn_team_zones()
	spawn_players()
	load_game_mode(world.game_mode_root)
	
	
	view_system.initialize(world, red_zone, blue_zone)
	
	game_mode.initialize(self)
	game_mode.start_match()


func spawn_team_zones():
	
	red_zone = team_zone_scene.instantiate()
	blue_zone = team_zone_scene.instantiate()
	
	arena.red_base_spawn.add_child(red_zone)
	arena.blue_base_spawn.add_child(blue_zone)
	
	red_zone.global_position = arena.red_base_spawn.global_position
	blue_zone.global_position = arena.blue_base_spawn.global_position

func get_camera_zones(team : Team.type):
	
	match team:
		Team.type.RED:
			return red_zone
		Team.type.BLUE:
			return blue_zone

func spawn_players():
	# clearing players array just in case
	players.clear()
	
	for i in range(match_config.players.size()):
		var config : PlayerConfig = match_config.players[i]
		
		var spawn_point : Node2D = arena.get_spawn_point(i)
		
		var player : Player = spawn_player(config, spawn_point)
		
		players.append(player)
		

func spawn_player(config : PlayerConfig, spawn_point : Node2D) -> Player:
	var p : Player = player_scene.instantiate()
	
	
	players_root.add_child(p)
	
	# inject runtime identity
	p.initialize(config.character_data, self)
	
	# assigning match spesific state
	p.team = config.team
	
	p.global_position = spawn_point.global_position
	
	return p

func load_arena(arena_root : Node2D):
	# adding the selected arena to the match scene
	arena = GameManager.match_config.arena_scene.instantiate()
	arena_root.add_child(arena)


func load_game_mode(game_mode_root : Node):
	# adding the selected mode to the match scene
	game_mode = GameManager.match_config.game_mode.instantiate()
	game_mode_root.add_child(game_mode)

# During runtime

func start_match():
	pass

func on_player_ko(player : Player):
	respawn_player(player)

func respawn_player(player):
	# respawns player
	# this need to reflect what team the player is on
	player.global_position = arena.get_spawn_point(0).global_position
	
	player.reset_for_respawn() # need to make this a function in player


func end_match():
	pass
