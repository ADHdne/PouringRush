extends Control
class_name PlayerIcon


var player: Player


@export var portrait : TextureRect
@onready var percent: Label = $Percent


func setup(p: Player):
	player = p

	portrait.texture = player.character_data.portrait

func _process(delta):
	if player == null:
		return

	percent.text = str(player.damage_component.percentage)
