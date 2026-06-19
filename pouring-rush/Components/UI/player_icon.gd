extends Control
class_name PlayerIcon


var player: Player


@export var portrait : TextureRect
@onready var health_bar: ProgressBar = $ProgressBar


func setup(p: Player):
	player = p

	portrait.texture = player.character_data.portrait

func _process(delta):
	if player == null:
		return

	health_bar.value = player.damage_component.percentage
