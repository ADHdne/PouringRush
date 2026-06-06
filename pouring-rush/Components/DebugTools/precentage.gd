extends Label
class_name Precentage

@export var player : Player


func _process(delta: float) -> void:
	if player != null:
		text = str(player.damage_component.percentage) + " %"
