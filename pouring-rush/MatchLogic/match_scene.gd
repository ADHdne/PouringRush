extends Node2D
class_name MatchScene


@onready var match_manager: MatchManager = $MatchManager

@onready var world: World = $World


@onready var ui: CanvasLayer = $UI





func _ready() -> void:
	
	# both viewports renders the same world
	
	
	match_manager.initialize(GameManager.match_config, world.arena_root, world.game_mode_root, world.players_root)
