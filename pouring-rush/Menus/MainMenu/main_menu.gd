extends Control
class_name MainMenu

# different menues first buttons
@export var first_button : Button


func _ready() -> void:
	
	if not SoundManager.menu_music.playing:
		SoundManager.menu_music.play()
	
	first_button.grab_focus()


func _on_host_game_button_pressed() -> void:
	# playing sound
	SoundManager.confirm.play()
	
	# opening lobby
	GameManager.load_lobby()

func _on_join_game_pressed() -> void:
	SoundManager.confirm.play()
	
	print("join game pressed")


func _on_options_button_pressed() -> void:
	
	SoundManager.confirm.play()
	
	print("Setting pressed")


func _on_exit_button_pressed() -> void:
	get_tree().quit()



# adding a sound for when buttons are hovered
func _on_focus_entered() -> void:
	SoundManager.button.play()
