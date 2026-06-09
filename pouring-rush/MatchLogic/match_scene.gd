extends Node2D
class_name MatchScene



@onready var match_manager: MatchManager = $MatchManager
@onready var arena_root: Node2D = $ArenaRoot
@onready var game_mode_root: Node = $GameModeRoot
@onready var players: Node2D = $Players
@onready var ui: CanvasLayer = $UI



func _ready() -> void:
	# adding the selected arena to the match scene
	var arena = GameManager.selected_arena.instantiate()
	arena_root.add_child(arena)
	
	# adding the selected mode to the match scene
	
	var game_mode = GameManager.selected_game_mode.instantiate()
	game_mode_root.add_child(game_mode)
	
	match_manager.initialize(arena, game_mode, players)
