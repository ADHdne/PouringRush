extends Node
class_name ViewSystem


@onready var blue_window: Window = $BlueWindow


@export var red_camera : TeamCamera
@export var blue_camera : TeamCamera


@export var red_match_ui : CanvasLayer
@export var blue_match_ui : CanvasLayer


@export var sub_viewport : SubViewport
@export var texture_rect : TextureRect

@export var pause_controller : PauseController
@export var red_pause_menu: PauseMenu
@export var blue_pause_menu: PauseMenu

@export var red_lobby : LobbyView
@export var blue_lobby : LobbyView

@export var red_victory : EndScreen
@export var blue_victory : EndScreen


@export var color_background : ColorRect


func _ready() -> void:
	red_camera.enabled = false
	blue_camera.enabled = false
	
	
	setup_windows()


	# called in match manager
func initialize(match_manager : MatchManager, match_scene : MatchScene, red_zone : TeamZone, blue_zone : TeamZone, players : Array[Player]):
	
	
	set_ui()
	
	red_match_ui.initialize(players, match_manager, red_pause_menu)
	blue_match_ui.initialize(players, match_manager, blue_pause_menu)
	
	var world = match_scene.world
	
	set_world(world, red_zone, blue_zone)



func set_world(world : World, red_zone : TeamZone, blue_zone : TeamZone):
	
	var shared_world = world.get_viewport().world_2d

	
	sub_viewport.world_2d = shared_world
	
	red_camera.make_current()
	blue_camera.make_current()
	
	red_camera.enabled = true
	blue_camera.enabled = true
	
	texture_rect.texture = sub_viewport.get_texture()

	red_camera.target_zone = red_zone
	blue_camera.target_zone = blue_zone

func set_ui():
	red_match_ui.team = Team.type.RED
	blue_match_ui.team = Team.type.BLUE
	

func setup_windows():

	get_window().current_screen = 0
	get_window().position = DisplayServer.screen_get_position(0)
	get_window().mode = Window.MODE_FULLSCREEN

	if DisplayServer.get_screen_count() > 1:

		blue_window.current_screen = 1
		blue_window.position = DisplayServer.screen_get_position(1)
		blue_window.mode = Window.MODE_FULLSCREEN
	

func deactivate_bars():
	red_match_ui.deactivate_bars()
	blue_match_ui.deactivate_bars()



#-------------------------------------
# Activating and deactivating the different stages of the game
#----------------------------------

func show_main_menu():

	hide_all()
	color_background.show()
	
	GameManager.current_state = GameManager.State.MENU



func show_lobby():
	
	hide_all()
	GameManager.current_state = GameManager.State.LOBBY
	
	red_camera.enabled = false
	blue_camera.enabled = false
	
	red_lobby.show()
	blue_lobby.show()

	red_match_ui.clear_for_match_end()
	blue_match_ui.clear_for_match_end()
	
	color_background.hide()
	



func show_match():
	
	GameManager.current_state = GameManager.State.MATCH
	
	red_camera.enabled = true
	blue_camera.enabled = true
	
	red_lobby.hide()
	blue_lobby.hide()

	red_match_ui.show()
	blue_match_ui.show()

	red_victory.hide()
	blue_victory.hide()



func show_victory():

	red_lobby.hide()
	blue_lobby.hide()

	red_match_ui.hide()
	blue_match_ui.hide()

	red_victory.show()
	blue_victory.show()



func hide_all():

	red_lobby.hide()
	blue_lobby.hide()

	red_match_ui.hide()
	blue_match_ui.hide()

	red_pause_menu.hide()
	blue_pause_menu.hide()

	red_victory.hide()
	blue_victory.hide()
	
	color_background.hide()
