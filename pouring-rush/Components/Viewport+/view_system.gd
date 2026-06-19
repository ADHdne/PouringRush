extends Node
class_name ViewSystem


@onready var blue_window: Window = $BlueWindow


@onready var red_camera: TeamCamera = $RedCamera
@onready var blue_camera: TeamCamera = $BlueWindow/SubViewport/BlueCamera


@onready var red_match_ui: MatchUI = $RedMatchUI
@onready var blue_match_ui: MatchUI = $BlueWindow/BlueMatchUI

@onready var sub_viewport: SubViewport = $BlueWindow/SubViewport
@onready var texture_rect: TextureRect = $BlueWindow/TextureRect




var world : World



func _ready() -> void:
	
	setup_windows()


	# called in match manager
func initialize(match_manager : MatchManager, world : World, red_zone : TeamZone, blue_zone : TeamZone, players : Array[Player]):
	
	red_camera.target_zone = red_zone
	blue_camera.target_zone = blue_zone
	
	red_match_ui.initialize(players, match_manager)
	blue_match_ui.initialize(players, match_manager)
	
	self.world = world
	
	set_world(world)
	
	set_ui()

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

		blue_window.current_screen = 0

		get_window().current_screen = 1
