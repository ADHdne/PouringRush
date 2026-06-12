extends Node
class_name ViewSystem


@onready var red_window: Window = $RedWindow
@onready var blue_window: Window = $BlueWindow

@onready var red_viewport: SubViewport = $RedWindow/RedViewport
@onready var blue_viewport: SubViewport = $BlueWindow/BlueViewport

@onready var red_camera: TeamCamera = $RedWindow/RedViewport/RedCamera
@onready var blue_camera: TeamCamera = $BlueWindow/BlueViewport/BlueCamera

var world : World

func _ready() -> void:
	red_window.show()
	blue_window.show()

func initialize(world : World, red_zone, blue_zone):
	
	red_camera.target_zone = red_zone
	blue_camera.target_zone = blue_zone
	
	self.world = world
	
	set_world(world)

func set_world(world : World):
	
	var shared_world = world.get_viewport().world_2d
	
	red_viewport.world_2d = shared_world
	blue_viewport.world_2d = shared_world
	
	red_viewport.get_camera_2d().make_current()
	blue_viewport.get_camera_2d().make_current()
	
	red_viewport.size = red_window.size
	blue_viewport.size = blue_window.size
	
	red_window.world_2d = red_viewport.world_2d
	blue_window.world_2d = blue_viewport.world_2d
