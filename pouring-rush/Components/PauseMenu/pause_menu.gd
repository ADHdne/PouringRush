extends Control
class_name PauseMenu


## references
@export var animation : AnimationPlayer
@export var pause_window : VBoxContainer
@export var resume_button : Button
@export var return_button : Button
@export var menu_open : bool = false

func _ready() -> void:
	# grabs first buttons focus
	resume_button.grab_focus()
	
	# removes it so it is not just invisible
	hide()
	get_tree().paused = false
	animation.play("RESET")


func resume():
	resume_button.grab_focus()
	resume_button.release_focus()
	get_tree().paused = false
	animation.play_backwards("Blur")
	SoundManager.menu_close.play()

func pause():
	# adds visibility and moves it in front
	pause_window.visible = true
	
	show()
	move_to_front()
	
	resume_button.grab_focus()
	get_tree().paused = true
	animation.play("Blur")
	SoundManager.menu_open.play()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Start") and not get_tree().paused:
		pause()
	elif event.is_action_pressed("Start") and get_tree().paused:
		resume()


func _on_resume_pressed() -> void:
	resume()


func _on_return_pressed() -> void:
	SoundManager.confirm.play()
	
	pause_window.visible = true
	resume_button.grab_focus()
	

func _on_quit_to_menu_pressed() -> void:
	resume()
	
	SoundManager.main_music.stop()
	SoundManager.deny.play()
	
	await get_tree().create_timer(0.20).timeout
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


# making sound when button is focused
func _on_focus_entered() -> void:
	SoundManager.button.play(0.18)
