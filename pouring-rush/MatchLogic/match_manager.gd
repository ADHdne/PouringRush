extends Node
class_name MatchManager


@onready var match_timer: Timer = $MatchTimer

@export var player_scene : PackedScene
@export var team_zone_scene: PackedScene

var match_config = MatchConfig

var view_system : ViewSystem

var arena : Arena
var game_mode : GameMode

var players : Array[Player]
var red_team_players : Array[Player]
var blue_team_players : Array[Player]

var players_root : Node2D

var red_zone : TeamZone
var blue_zone : TeamZone

var red_base : SafeZoneArea
var blue_base : SafeZoneArea

var is_paused : bool = false

var match_in_progress : bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

# this gets called from match_scene
func initialize(match_config : MatchConfig, world : World, view_system : ViewSystem):
	
	self.match_config = match_config
	self.players_root = world.players_root
	self.view_system = view_system
	
	load_arena(world.arena_root)
	spawn_team_zones()
	get_team_bases()
	spawn_players()
	set_team()
	load_game_mode(world.game_mode_root)
	
	
	view_system.initialize(self, world, red_zone, blue_zone, players)
	
	match match_config.game_mode_type:
		SelectedMode.Mode.PUSH:
			game_mode.init(arena.push_lane, arena.push_lane.pusher, arena.push_lane.red_barrier, arena.push_lane.blue_barrier)
			arena.control_zone.deactivate()
			view_system.deactivate_bars()
		SelectedMode.Mode.CONTROL:
			game_mode.init(arena.control_zone, view_system)
			arena.push_lane.deactivate()
	game_mode.initialize(self)
	start_match()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Start") and not is_paused:
		pause()
	elif event.is_action_pressed("Start") and is_paused:
		unpause()



func spawn_team_zones():
	
	red_zone = team_zone_scene.instantiate()
	blue_zone = team_zone_scene.instantiate()
	
	red_zone.team = Team.type.RED
	blue_zone.team = Team.type.BLUE
	
	arena.red_base.add_child(red_zone)
	arena.blue_base.add_child(blue_zone)
	
	red_zone.global_position = arena.red_base.global_position
	blue_zone.global_position = arena.blue_base.global_position

func get_team_bases():
	red_base = arena.red_base
	blue_base = arena.blue_base

func get_team_zones(team : Team.type):
	
	match team:
		Team.type.RED:
			return red_zone
		Team.type.BLUE:
			return blue_zone

func get_base_zones(team : Team.type):
	
	match team:
		Team.type.RED:
			return red_base
		Team.type.BLUE:
			return blue_base

func get_safe_zones(team : Team.type) -> Array[SafeZoneArea]:
	
	var zones : Array[SafeZoneArea]
	
	match team:
		Team.type.RED:
			if red_zone:
				zones.append(red_zone)
			if red_base:
				zones.append(red_base)
		Team.type.BLUE:
			if blue_zone:
				zones.append(blue_zone)
			if blue_base:
				zones.append(blue_base)
	
	return zones

func get_spawn_point(team : Team.type) -> Node2D:
	var points = arena.red_spawn_points if team == Team.type.RED else arena.blue_sp0awn_points2
	
	return points.pick_random()



func spawn_players():
	# clearing players array just in case
	players.clear()
	
	for i in range(match_config.players.size()):
		var config : PlayerConfig = match_config.players[i]
		
		
		var player : Player = spawn_player(config)
		
		# setting id
		player.player_index = i
		
		player.set_color()
		
		# setting controls
		player.player_actions = config.player_actions[i]
		
		players.append(player)
		

func spawn_player(config : PlayerConfig) -> Player:
	var p : Player = player_scene.instantiate()
	
	
	players_root.add_child(p)
	
	# inject runtime identity
	p.initialize(config.character_data, self)
	
	# assigning match spesific state
	p.team = config.team
	
	arena.assign_spawn_points(p)
	
	p.global_position = p.spawn.global_position
	
	# setting the spesific players teamzone
	p.carry_component.zone = get_team_zones(p.team)
	
	# setting outline color
	match p.team:
		Team.type.RED:
			p.outline.modulate = Color(1,0,0)
		Team.type.BLUE:
			p.outline.modulate = Color(0,0,1)
	
	return p

func set_team():
	for p in players:
		if p.team == Team.type.RED:
			red_team_players.append(p)
		else:
			blue_team_players.append(p)

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
	game_mode.start_match()
	match_timer.start(game_mode.match_time)
	
	match_in_progress = true

func pause():
	match_timer.paused = true
	is_paused = true
	view_system.red_pause_menu.pause()
	view_system.blue_pause_menu.pause()

func unpause():
	match_timer.paused = false
	view_system.red_pause_menu.resume()
	view_system.blue_pause_menu.resume()
	is_paused = false


func get_time_remaining() -> float:
	return match_timer.time_left

func on_player_ko(player : Player):
	check_team_elimination(player.team)

func respawn_team(team : Team.type):
	match team:
		Team.type.RED:
			for p in red_team_players:
				if not p.alive:
					respawn_player(p)
		Team.type.BLUE:
			for p in blue_team_players:
				if not p.alive:
					respawn_player(p)

func respawn_player(player):
	# respawns player
	# this need to reflect what team the player is on
	player.global_position = player.spawn.global_position
	
	player.reset_for_respawn()

func reset_team_zone(team: Team.type):

	var zone = get_team_zones(team)
	var base = arena.get_base(team)

	zone.carrier = null
	zone.velocity = Vector2.ZERO

	zone.global_position = base.global_position

func check_team_elimination(team: Team.type):

	for player in players:

		if player.team != team:
			continue

		if player.alive:
			return
	
	reset_team_zone(team)
	
	# waiting before respawning team
	await get_tree().create_timer(10).timeout
	respawn_team(team)


func end_match():
	
	match_in_progress = false
	
	# stops clocks from ticking down if time out
	SoundManager.clock_tick_fast.stop()
	SoundManager.clock_tick_slow.stop()
	
	# stopping the music
	SoundManager.main_music.stop()


func _on_match_timer_timeout() -> void:
	game_mode.match_timer_timeout()
	end_match()
