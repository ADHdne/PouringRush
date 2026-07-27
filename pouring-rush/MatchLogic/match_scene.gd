extends Node2D
class_name MatchScene


@onready var match_manager: MatchManager = $MatchManager
@onready var world: World = $World
@onready var view_system: ViewSystem = $ViewSystem
@onready var match_ui: MatchUI = $MatchUI





func _ready() -> void:
	
	# both viewports renders the same world
	match_manager.initialize(GameManager.match_config, world, view_system)


func initialize():
	pass
	# self.viesystem = viewsystem
