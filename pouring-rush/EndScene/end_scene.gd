extends Control
class_name EndScreen


@onready var label: Label = $HBoxContainer/VBoxContainer/Label


@export var winning_team : String


func _ready() -> void:
	winning_team = GameManager.winning_team
	
	label.text = winning_team
