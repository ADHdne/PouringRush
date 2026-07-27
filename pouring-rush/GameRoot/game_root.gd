extends Node
class_name GameRoot


@export var main_menu : Control
@export var view_system : ViewSystem
@export var current_game : Node

@export var match_manager : MatchManager

@export var match_scene : PackedScene

@export var current_match_scene : MatchScene

func _ready():
	
	GameManager.game_root = self
	
	show_main_menu()



func show_main_menu():

	main_menu.show()

	view_system.show_main_menu()



func show_lobby():

	main_menu.hide()

	view_system.show_lobby()

func return_to_lobby():
	match_manager.end_match()
	
	view_system.red_camera.enabled = false
	view_system.blue_camera.enabled = false
	
	view_system.red_pause_menu.hide()
	view_system.blue_pause_menu.hide()
	
	if current_game != null:
		for child in current_game.get_children():
			child.queue_free()
	
	view_system.show_lobby()

func start_match():
	
	if current_game != null:
		for child in current_game.get_children():
			child.queue_free()


	var match_instance = match_scene.instantiate()
	
	current_game.add_child(match_instance)
	
	current_match_scene = current_game.get_child(0)
	
	# both viewports renders the same world
	match_manager.initialize(GameManager.match_config, current_match_scene, view_system)
	
	view_system.show_match()
	

func show_victory():

	view_system.show_victory()
