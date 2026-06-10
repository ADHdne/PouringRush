extends Node2D
class_name Arena


@onready var camera_bounds: CameraBounds = $CameraBounds
@onready var spawn_points: Node2D = $SpawnPoints
@onready var red_base_spawn: Node2D = $RedBaseSpawn
@onready var blue_base_spawn: Node2D = $BlueBaseSpawn


func get_spawn_point(index : int) -> Marker2D:
	return spawn_points.spawn_points[index]


func get_objective_start():
	pass


func get_camera_bounds() -> Rect2:
	var tl = camera_bounds.get_node("TopLeft").global_position
	var br = camera_bounds.get_node("BottomRight").global_position
	return Rect2(tl, br - tl)
