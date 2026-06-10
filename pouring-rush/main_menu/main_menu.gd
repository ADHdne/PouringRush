extends Control
class_name MainMenu

# different menues first buttons
@export var first_button : Button

# different menues
@export var start_menu : VBoxContainer
@export var host_game_menu : VBoxContainer
@export var character_selection_menu : VBoxContainer
@export var choose_team_menu : VBoxContainer


# reference to other children
@export var number_of_players_label : Label
@export var game_text : Label


# Characterr Rooster
var rooster : Array[CharacterData] = [
	preload("res://Resources/TestCharacter1.tres"), # test character 1
]

var arenas : Array[PackedScene] = [
	preload("res://World/grass_lands.tscn"), # grass land arena
]

var game_modes : Array[PackedScene] = [
	preload("res://GameModes/stock_mode.tscn")
	
]

 # Different variables for logic
var saved_location : StringName

var last_menu : VBoxContainer
var current_menu : VBoxContainer


var players : Array[PlayerConfig]
var number_of_players : int = 2


var active_player : PlayerConfig

func _ready() -> void:
	# turns of visibility of the other screens
	open_menu(start_menu)
	
	current_menu = start_menu
	
	# set number of player label
	number_of_players_label.text = "Number Of Players: 2"



## Opening / Close Menu

func close_menu():
	start_menu.visible = false
	host_game_menu.visible = false
	character_selection_menu.visible = false
	choose_team_menu.visible = false

func open_menu(menu : VBoxContainer):
	# close all menues
	close_menu()
	
	# make the correct menu visible
	menu.visible = true
	
	# find the first button in menu
	for c in menu.get_children():
		if c is Button:
			first_button = c
			break # stop the cycle
	# grab first buttons focus
	first_button.grab_focus()
	
	# set last menu and current menues
	last_menu = current_menu
	current_menu = menu

## different logical functions

func choose_team(character_data : CharacterData):
	pass

func update_nop_label(value : int):
	number_of_players_label.text = ("Number of players: " + str(value))

func start_match():
	var config = MatchConfig.new()
	config.players = players
	
	# both arena and game mode should be choosable in this menu in the future
	config.arena_scene = arenas[0]
	config.game_mode = game_modes[0]
	
	GameManager.match_config = config
	
	GameManager.start_match()


## General buttons

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
	open_menu(character_selection_menu)
	
	# starting the new character
	active_player = PlayerConfig.new()

func _on_add_player_button_pressed() -> void:
	number_of_players += 1
	
	if number_of_players >= 9 :
		number_of_players = 8
		print("max players reached")
	
	update_nop_label(number_of_players)


func _on_remove_player_button_pressed() -> void:
	number_of_players -= 1
	
	if number_of_players <= 1:
		number_of_players = 2
		# need at least 2 players
	
	update_nop_label(number_of_players)



## Character Selection Menu

func _on_character_1_pressed() -> void:
	# setting character_data to active character
	active_player.character_data = rooster[0]
	
	
	open_menu(choose_team_menu)



## Choose Team Menu


func _on_team_1_button_pressed() -> void:
	# chooses team
	active_player.team = Team.type.RED
	
	# adds active player to players array
	players.append(active_player)
	
	
	if number_of_players > players.size():
		# go back to character select for next character?
		active_player = PlayerConfig.new()
		open_menu(last_menu)
	else:
		start_match()
	


func _on_team_2_button_pressed() -> void:
	pass # Replace with function body.
