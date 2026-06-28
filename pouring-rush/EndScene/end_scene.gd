extends Control
class_name EndScreen


@onready var label: Label = $HBoxContainer/VBoxContainer/Label
@onready var color_rect: Panel = $ColorRect



@export var winning_team : String


func _ready() -> void:
	winning_team = GameManager.winning_team
	
	label.text = winning_team
	
	var panel_stylebox = color_rect.get_theme_stylebox("panel") as StyleBoxTexture
	
	
	# 3. Modify the texture modulate color
	if winning_team == "Victory for the Red Team":
		panel_stylebox.modulate_color = Color(0.478, 0.157, 0.125, 0.62)
	elif winning_team == "Victory for the Blue Team":
		panel_stylebox.modulate_color = Color(0.275, 0.306, 0.537, 0.62)
	else:
		panel_stylebox.modulate_color = Color(0.227, 0.337, 0.0, 0.62)
	
	# 4. Re-apply the updated StyleBox back to the Panel's theme overrides
	add_theme_stylebox_override("panel", panel_stylebox)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Start"):
		get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
