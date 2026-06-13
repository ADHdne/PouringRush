extends Node2D
class_name Arena


@onready var camera_bounds: CameraBounds = $CameraBounds
@onready var red_spawn_points: SpawnPoints = $RedSpawnPoints
@onready var blue_spawn_points: SpawnPoints = $BlueSpawnPoints
@onready var red_base_spawn: Node2D = $RedBaseSpawn
@onready var blue_base_spawn: Node2D = $BlueBaseSpawn

var red_spawns : Array[Node]
var blue_spawns : Array[Node]

var red_index : = 0
var blue_index : = 0

func _ready() -> void:
	
	red_spawns = red_spawn_points.get_children()
	blue_spawns = blue_spawn_points.get_children()

func get_team_spawns(points : SpawnPoints):
	for c in points.get_children():
		if c.team == Team.type.RED:
			red_spawns.append(c)
		else:
			blue_spawns.append(c)

func get_spawn_point(team: Team.type) -> SpawnPoint:

	if team == Team.type.RED:
		return red_spawns[red_index % red_spawns.size()]

	return blue_spawns[blue_index % blue_spawns.size()]

func assign_spawn_points(player : Player):
	
	player.spawn = get_spawn_point(player.team)
	if player.team == Team.type.RED:
		red_index += 1
	else:
		blue_index += 1

func get_objective_start():
	pass


func get_camera_bounds() -> Rect2:
	var tl = camera_bounds.get_node("TopLeft").global_position
	var br = camera_bounds.get_node("BottomRight").global_position
	return Rect2(tl, br - tl)
	
func get_base(team : Team.type) -> Node2D:
	if team == Team.type.RED:
		return red_base_spawn
	else:
		return blue_base_spawn
