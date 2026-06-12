extends Node
class_name ViewSystem


@onready var blue_window: Window = $BlueWindow


@onready var red_camera: TeamCamera = $RedCamera
@onready var blue_camera: TeamCamera = $BlueWindow/BlueCamera

var world : World

func _ready() -> void:
	blue_window.show()

	# called in match manager
func initialize(world : World, red_zone : TeamZone, blue_zone : TeamZone):
	
	red_camera.target_zone = red_zone
	blue_camera.target_zone = blue_zone
	
	self.world = world
	
	set_world(world)

func set_world(world : World):
	
	var shared_world = world.get_viewport().world_2d
	
	blue_window.world_2d = shared_world
	
	red_camera.make_current()
	blue_window.get_camera_2d().make_current()
