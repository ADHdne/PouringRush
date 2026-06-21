extends Node
class_name EnemySpawnHandler

signal enemy_data_loaded

var value : bool = false


func _ready() -> void:
	get_value()

func set_value() -> void:
	SaveManager.save_data.scene_data.add_enemy_value(_get_name())


func get_value() -> void:
	value = SaveManager.save_data.scene_data.check_enemy_value(_get_name())
	enemy_data_loaded.emit()

func _get_name() -> String:
	# the filepaths will look something like
	# "res://world/test_levels/test_level1.tscn"
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name
