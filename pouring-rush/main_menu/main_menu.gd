extends Control
class_name MainMenu

# different menues first buttons
@export var first_button : Button

# different menues
@export var start_menu : VBoxContainer
@export var host_game_menu : VBoxContainer
@export var character_selection_menu : VBoxContainer
@export var choose_team_menu : VBoxContainer
@export var choose_game_mode_menu : VBoxContainer


# reference to other children
@export var number_of_players_label : Label
@export var game_text : Label
@export var menu_title : Label


# Characterr Rooster
var rooster : Array[CharacterData] = [
	preload("res://Resources/TestDPSCharacter/test_dps_character.tres"), # test dps character
	preload("res://Resources/TestSupportCharacter/test_support_character.tres")
]

var arenas : Array[PackedScene] = [
	preload("res://World/grass_lands.tscn"), # grass land arena
]

var game_modes : Array[PackedScene] = [
	preload("res://GameModes/Stock/stock_mode.tscn"),
	preload("res://GameModes/Push/push_mode.tscn"),
	preload("res://GameModes/Control/control_mode.tscn")
	
]

 # Different variables for logic
var saved_location : StringName

var current_menu : VBoxContainer


var players : Array[PlayerConfig]
var number_of_players : int = 2

var config : MatchConfig

var active_player : PlayerConfig

var game_mode_selected : int


func _ready() -> void:
	# turns of visibility of the other screens
	open_menu(start_menu)
	
	current_menu = start_menu
	
	# set number of player label
	number_of_players_label.text = "Number Of Players: 2"
	
	SoundManager.menu_music.play()
	
	config = MatchConfig.new()



## Opening / Close Menu

func close_menu():
	start_menu.visible = false
	choose_game_mode_menu.visible = false
	host_game_menu.visible = false
	character_selection_menu.visible = false
	choose_team_menu.visible = false

func open_menu(menu : VBoxContainer):
	# close all menues
	close_menu()
	
	# make the currect menu visible
	menu.visible = true
	
	# find the first button in menu
	for c in menu.get_children():
		if c is Button:
			first_button = c
			break # stop the cycle
	# grab first buttons focus
	first_button.grab_focus()
	
	# updating menu title
	update_menu_title(menu)
	
	# set current menues
	current_menu = menu

## different logical functions


func update_nop_label(value : int):
	number_of_players_label.text = ("Number of Players: " + str(value))

func update_menu_title(menu : VBoxContainer):
	match menu.name:
		"HostGameMenu":
			menu_title.text = "Player Amount"
		
		"ChooseGameMode":
			menu_title.text = "Choose Game Mode"
			
		"ChooseTeamMenu":
			menu_title.text = "Select Team"
			
		"CharacterSelectionMenu":
			menu_title.text = "Select Character"
			
		"StartMenu":
			menu_title.text = "Start Menu"
		

func start_match():
	
	config.players = players
	
	
	# both arena and game mode should be choosable in this menu in the future
	config.arena_scene = arenas[0]
	
	config.game_mode = game_modes[game_mode_selected]
	# also setting the game mode as matchable var
	if game_mode_selected == 1:
		config.game_mode_type = SelectedMode.Mode.PUSH
	elif game_mode_selected == 2:
		config.game_mode_type = SelectedMode.Mode.CONTROL
	
	GameManager.match_config = config
	
	SoundManager.press_start.play()
	
	SoundManager.menu_music.stop()
	
	SoundManager.main_music.play()
	
	GameManager.start_match()

## General buttons

func _on_return_button_pressed() -> void:
	var last_menu : VBoxContainer
	
	if current_menu == host_game_menu:
		last_menu = start_menu
	elif current_menu == character_selection_menu or choose_team_menu:
		last_menu = host_game_menu
		players.clear()
		game_text.text = ""
		active_player = null
	
	SoundManager.deny.play()
	
	open_menu(last_menu)


## Start Menu


func _on_host_game_button_pressed() -> void:
	# opening the next menu
	open_menu(choose_game_mode_menu)
	
	SoundManager.confirm.play()

func _on_join_game_pressed() -> void:
	SoundManager.confirm.play()
	
	print("join game pressed")


func _on_options_button_pressed() -> void:
	
	SoundManager.confirm.play()
	
	print("Setting pressed")


func _on_exit_button_pressed() -> void:
	get_tree().quit()



## Choose Game Mode Menu

func _on_push_mode_pressed() -> void:
	
	game_mode_selected = 1
	
	open_menu(host_game_menu)

func _on_control_pressed() -> void:
	
	game_mode_selected = 2
	
	open_menu(host_game_menu)



## host game menu

func _on_select_team_buttons_pressed() -> void:
	
	# starting the new character
	active_player = PlayerConfig.new()
	
	# setting first players caracters id
	active_player.input_id = players.size()
	
	game_text.text = "Configuring Player " + str(active_player.input_id + 1)
	
	SoundManager.confirm.play()
	
	# opening the next menu
	open_menu(choose_team_menu)

func _on_add_player_button_pressed() -> void:
	number_of_players += 1
	
	if number_of_players >= 9 :
		number_of_players = 8
		print("max players reached")
	
	update_nop_label(number_of_players)
	
	SoundManager.confirm.play()


func _on_remove_player_button_pressed() -> void:
	number_of_players -= 1
	
	if number_of_players <= 1:
		number_of_players = 2
		# need at least 2 players
	
	update_nop_label(number_of_players)
	
	SoundManager.confirm.play()



## Choose Team Menu


func _on_team_1_button_pressed() -> void:
	# chooses team
	active_player.team = Team.type.RED
	
	# open the menu
	open_menu(character_selection_menu)
	
	SoundManager.confirm.play()



func _on_team_2_button_pressed() -> void:
	# chooses team
	active_player.team = Team.type.BLUE
	
	# opening the menu
	open_menu(character_selection_menu)
	
	SoundManager.confirm.play()



## Character Selection Menu

func _on_character_1_pressed() -> void:
	# setting character_data to active character
	active_player.character_data = rooster[0]
	
	add_and_check_player()
	
	SoundManager.confirm.play()

func _on_character_2_button_pressed() -> void:
	# setting character_data to active character
	active_player.character_data = rooster[1]
	
	add_and_check_player()
	
	SoundManager.confirm.play()


func add_and_check_player():
	
	# adds active player to players array
	players.append(active_player)
	
	
	if number_of_players > players.size():
		# go back to character select for next character?
		active_player = PlayerConfig.new()
		
		# setting players id
		active_player.input_id = players.size()
		
		# updating whitch players configuring label
		game_text.text = "Configuring Player " + str(active_player.input_id + 1)
		
		# goes back to choose team for the same order again
		open_menu(choose_team_menu)
		
	else:
		start_match()

# adding a sound for when buttons are hovered
func _on_focus_entered() -> void:
	SoundManager.button.play(0.18)
