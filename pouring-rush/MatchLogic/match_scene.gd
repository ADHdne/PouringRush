extends Node2D
class_name MatchScene


@onready var match_manager: MatchManager = $MatchManager

@onready var arena_root: Node2D = $ArenaRoot
@onready var game_mode_root: Node = $GameModeRoot
@onready var players: Node2D = $Players

@onready var ui: CanvasLayer = $UI





func _ready() -> void:
	
	# both viewports renders the same world
	
	
	match_manager.initialize(GameManager.match_config, arena_root, game_mode_root, players)
