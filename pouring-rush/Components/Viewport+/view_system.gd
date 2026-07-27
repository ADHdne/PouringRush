extends Node
class_name ViewSystem


@onready var blue_window: Window = $BlueWindow


@onready var red_camera: TeamCamera = $RedCamera
@onready var blue_camera: TeamCamera = $BlueWindow/SubViewport/BlueCamera


@export var red_match_ui : CanvasLayer
@export var blue_match_ui : CanvasLayer


@onready var sub_viewport: SubViewport = $BlueWindow/SubViewport
@onready var texture_rect: TextureRect = $BlueWindow/TextureRect

@export var red_pause_menu: PauseMenu
@export var blue_pause_menu: PauseMenu

@export var red_lobby : LobbyView
@export var blue_lobby : LobbyView

@export var red_victory : EndScreen
@export var blue_victory : EndScreen


var world : World


func _ready() -> void:
	
	setup_windows()


	# called in match manager
func initialize(match_manager : MatchManager, world : World, red_zone : TeamZone, blue_zone : TeamZone, players : Array[Player]):
	
	red_camera.target_zone = red_zone
	blue_camera.target_zone = blue_zone
	
	
	set_ui()
	
	red_match_ui.initialize(players, match_manager, red_pause_menu)
	blue_match_ui.initialize(players, match_manager, blue_pause_menu)
	
	self.world = world
	
	set_world(world)



func set_world(world : World):
	
	var shared_world = world.get_viewport().world_2d
	
	sub_viewport.world_2d = shared_world
	
	red_camera.make_current()
	blue_camera.make_current()
	
	texture_rect.texture = sub_viewport.get_texture()


func set_ui():
	red_match_ui.team = Team.type.RED
	blue_match_ui.team = Team.type.BLUE
	

func setup_windows():
	if DisplayServer.get_screen_count() > 1:

		blue_window.show()
		await get_tree().process_frame

		blue_window.current_screen = 1
		blue_window.mode = Window.MODE_FULLSCREEN

		get_window().current_screen = 0
		get_window().mode = Window.MODE_FULLSCREEN
	









func show_main_menu():

	hide_all()



func show_lobby():

	red_lobby.show()
	blue_lobby.show()

	red_match_ui.hide()
	blue_match_ui.hide()

	red_victory.hide()
	blue_victory.hide()



func show_match():

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
