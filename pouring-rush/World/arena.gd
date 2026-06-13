extends Node2D
class_name Arena


@onready var camera_bounds: CameraBounds = $CameraBounds
@onready var red_spawn_points: SpawnPoints = $RedSpawnPoints
@onready var blue_spawn_points: SpawnPoints = $BlueSpawnPoints
@onready var red_base_spawn: Node2D = $RedBaseSpawn
@onready var blue_base_spawn: Node2D = $BlueBaseSpawn

var red_spawns : Array[SpawnPoint]
var blue_spawns : Array[SpawnPoint]


func get_spawn_point(team : Team.type) -> Array[SpawnPoint]:
	
	if team == Team.type.RED:
		return red_spawns
	
	return blue_spawns

func assign_spawn_points(players : Array[Player]):
	var red_index : = 0
	var blue_index : = 0
	
	for player in players:
		match player.team:
			Team.type.RED:
				player.spawn = red_spawns[red_index]
				red_index += 1
			Team.type.BLUE:
				player.spawn = blue_spawns[blue_index]
				blue_index += 1

func get_objective_start():
	pass


func get_camera_bounds() -> Rect2:
	var tl = camera_bounds.get_node("TopLeft").global_position
	var br = camera_bounds.get_node("BottomRight").global_position
	return Rect2(tl, br - tl)
