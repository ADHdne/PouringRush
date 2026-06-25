extends Control
class_name EndScreen


@onready var label: Label = $HBoxContainer/VBoxContainer/Label
@onready var color_rect: ColorRect = $ColorRect


@export var winning_team : String


func _ready() -> void:
	winning_team = GameManager.winning_team
	
	label.text = winning_team
	
	if winning_team == "Victory for the Red Team":
		color_rect.color = Color(0.4, 0.1, 0.1)
	elif winning_team == "Victory for the Blue Team":
		color_rect.color = Color(0.1, 0.1, 0.4)
	else:
		color_rect.color = Color(0.2, 0.4, 0)
