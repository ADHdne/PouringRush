extends Control
class_name Lobby





## player list

@export var player_slots : Array[PlayerSlot]

@export var first_button : Button
@export var game_mode_label : Label
@export var arena_label : Label
@export var start_button : Button
@export var ready_label : Label

const MAX_PLAYERS : int = 8

var arenas : Array[PackedScene] = [
	preload("res://World/grass_lands.tscn"), # grass land arena
]

var game_modes : Array[PackedScene] = [
	preload("res://GameModes/Stock/stock_mode.tscn"),
	preload("res://GameModes/Push/push_mode.tscn"),
	preload("res://GameModes/Control/control_mode.tscn")
]

## match settings

var selected_arena := 0
var selected_game_mode := 0

var config : MatchConfig


func _ready() -> void:

	config = MatchConfig.new()

	update_settings_ui()

	for slot in player_slots:

		slot.player_joined.connect(update_lobby)
		slot.player_left.connect(update_lobby)
		slot.ready_changed.connect(update_lobby)

	update_lobby()

	first_button.grab_focus()

# ------------------------
# Lobby status
# ------------------------

func update_lobby():

	var players_ready := true
	var player_count := 0


	for slot in player_slots:

		if slot.has_player():

			player_count += 1

			if !slot.player_config.ready:
				players_ready = false


	# need at least 2 players
	var can_start := player_count >= 2 and players_ready


	start_button.disabled = !can_start


	ready_label.text = (
		str(player_count) 
		+ " Players"
	)



# ------------------------
# Match settings
# ------------------------

func next_game_mode():

	selected_game_mode += 1

	if selected_game_mode >= game_modes.size():
		selected_game_mode = 0

	update_settings_ui()



func next_arena():

	selected_arena += 1

	if selected_arena >= arenas.size():
		selected_arena = 0

	update_settings_ui()



func update_settings_ui():

	game_mode_label.text = game_modes[selected_game_mode].resource_path.get_file().get_basename()

	arena_label.text = arenas[selected_arena].resource_path.get_file().get_basename()



# ------------------------
# Start match
# ------------------------

func start_match():

	if start_button.disabled:
		return


	var players : Array[PlayerConfig] = []


	for slot in player_slots:

		if slot.has_player():

			players.append(slot.player_config)



	var match_config := MatchConfig.new()

	match_config.players = players

	match_config.arena_scene = arenas[selected_arena]

	match_config.game_mode = game_modes[selected_game_mode]


	match selected_game_mode:

		0:
			match_config.game_mode_type = SelectedMode.Mode.STOCK

		1:
			match_config.game_mode_type = SelectedMode.Mode.PUSH

		2:
			match_config.game_mode_type = SelectedMode.Mode.CONTROL



	GameManager.match_config = match_config


	SoundManager.press_start.play()
	SoundManager.menu_music.stop()
	SoundManager.main_music.play()


	GameManager.start_match()


func join_player(device_id):

	for slot in player_slots:

		if !slot.has_player():

			slot.join(device_id)
			return

## buttons


func _on_game_mode_button_pressed() -> void:
	next_game_mode()


func _on_arena_button_pressed() -> void:
	next_arena()


func _on_start_button_pressed() -> void:
	start_match()


func _on_back_button_pressed() -> void:
	# goes to main menu
	get_tree().change_scene_to_file("res://Menus/MainMenu/main_menu.tscn")


func _on_focus_entered() -> void:
	SoundManager.button.play()
