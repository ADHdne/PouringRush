extends Control
class_name EndScreen


var match_manager : MatchManager

@onready var label: Label = $HBoxContainer/VBoxContainer/Label
@onready var color_rect: Panel = $ColorRect


var panel_stylebox : StyleBoxTexture


var match_ended : bool = false


func _ready() -> void:
	
	match_ended = false
	
	panel_stylebox = color_rect.get_theme_stylebox("panel") as StyleBoxTexture

func _input(event: InputEvent) -> void:
	if match_ended:
		if event.is_action_pressed("Start"):
			GameManager.load_main_menu()


func end_game(winning_team : String):
	
	label.text = winning_team
	
	# 3. Modify the texture modulate color
	if winning_team == "Victory for the Red Team":
		panel_stylebox.modulate_color = Color(0.478, 0.157, 0.125, 0.62)
	elif winning_team == "Victory for the Blue Team":
		panel_stylebox.modulate_color = Color(0.275, 0.306, 0.537, 0.62)
	else:
		panel_stylebox.modulate_color = Color(0.227, 0.337, 0.0, 0.62)
	
	# 4. Re-apply the updated StyleBox back to the Panel's theme overrides
	add_theme_stylebox_override("panel", panel_stylebox)
	
	# playes end scene music 
	SoundManager.big_droplet.play() # only big droplet
	
	match_ended = true
	print("playing music")
