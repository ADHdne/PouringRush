extends Node2D
class_name SpawnPoints


@export var spawn_points : Array

func _ready() -> void:
	for c in get_children():
		if c is Marker2D:
			spawn_points.append(c)
