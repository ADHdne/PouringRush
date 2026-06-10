extends Control
class_name MainMenu

# different menues first buttons
@export var host_game_button : Button
@export var select_character : Button
@export var character_1_button : Button

# different menues
@export var start_menu : VBoxContainer
@export var host_game_menu : VBoxContainer

var new_game_position

var saved_location : StringName

var last_menu : VBoxContainer
var current_menu : VBoxContainer

func _ready() -> void:
	# turns of visibility of the other screens
	host_game_button.visible = false
	# turns on visibility for start menu
	start_menu.visible = true
	
	host_game_button.grab_focus()
	current_menu = start_menu
	



## Opening / Close Menu

func close_menu():
	start_menu.visible = false
	host_game_menu.visible = false

func open_menu(menu : VBoxContainer):
	# close all menues
	close_menu()
	
	# make the correct menu visible
	menu.visible = true
	
	# set last menu and current menues
	last_menu = current_menu
	current_menu = menu



## General buttons

## return to start menu
func _on_return_button_pressed() -> void:
	open_menu(last_menu)


## Start Menu

func _on_host_game_pressed() -> void:
	open_menu(host_game_menu)
	

func _on_join_game_pressed() -> void:
	pass # Replace with function body.


func _on_options_button_pressed() -> void:
	print("Setting pressed")


func _on_exit_button_pressed() -> void:
	get_tree().quit()



## host game menu

func _on_select_character_pressed() -> void:
	pass # Replace with function body.





## Character Selection Menu

func _on_character_1_pressed() -> void:
	pass # Replace with function body.
