extends Control
class_name Lobby


## Player list

@export var player_slots : Array[PlayerSlot]

@export var game_mode_label : Label
@export var arena_label : Label
@export var ready_label : Label
@export var start_label : Label


const MAX_PLAYERS : int = 8

enum HostState {
	PLAYER_SETUP,
	MATCH_SETTINGS
}


var arenas : Array[PackedScene] = [
	preload("res://World/grass_lands.tscn")
]


var game_modes : Array[PackedScene] = [
	preload("res://GameModes/Stock/stock_mode.tscn"),
	preload("res://GameModes/Push/push_mode.tscn"),
	preload("res://GameModes/Control/control_mode.tscn")
]


## Match settings

var selected_arena := 0
var selected_game_mode := 0


var host_id : int = -1
var host_state : HostState


func _ready() -> void:

	update_settings_ui()

	for slot in player_slots:

		slot.player_joined.connect(update_lobby)
		slot.player_left.connect(update_lobby)
		slot.ready_changed.connect(update_lobby)

	update_lobby()



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


	var can_start := player_count >= 2 and players_ready


	if can_start:
		start_label.text = "Press Start to Begin"
	else:
		start_label.text = "Waiting for players..."


	ready_label.text = str(player_count) + " Players"
	
	var host_slot := get_host_slot()
	
	if host_slot:
		if host_slot.player_config.ready:
			host_state = HostState.MATCH_SETTINGS
		else:
			host_state = HostState.PLAYER_SETUP



# ------------------------
# Match settings
# ------------------------

func next_game_mode():

	selected_game_mode += 1

	if selected_game_mode >= game_modes.size():
		selected_game_mode = 0

	update_settings_ui()



func previous_game_mode():

	selected_game_mode -= 1

	if selected_game_mode < 0:
		selected_game_mode = game_modes.size() - 1

	update_settings_ui()



func next_arena():

	selected_arena += 1

	if selected_arena >= arenas.size():
		selected_arena = 0

	update_settings_ui()

func previous_arena():
	
	selected_arena -= 1

	if selected_arena < 0:
		selected_arena = arenas.size() - 1

	update_settings_ui()

func update_settings_ui():

	game_mode_label.text = (
		game_modes[selected_game_mode]
		.resource_path
		.get_file()
		.get_basename()
	)


	arena_label.text = (
		arenas[selected_arena]
		.resource_path
		.get_file()
		.get_basename()
	)



# ------------------------
# Start match
# ------------------------

func start_match():

	if !can_start_match():
		return


	var match_config := MatchConfig.new()


	for slot in player_slots:

		if slot.has_player():

			match_config.players.append(slot.player_config)



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



func can_start_match() -> bool:

	var player_count := 0


	for slot in player_slots:

		if slot.has_player():

			player_count += 1

			if !slot.player_config.ready:
				return false


	return player_count >= 2



# ------------------------
# Input
# ------------------------

func _unhandled_input(event):
# this makes the other loby inputs not work. How should the host tell lobby that its done with character options and ready for match settings without fucking up this logic for the other characters?
	
	# If this controller is not already in the lobby, join on press start
	if event.is_action_pressed("Start"):
	
		if !player_has_joined(event.device):

			add_player(event.device)

			return
	
	
	# only host controls lobby
	if event.device != host_id:
		return
	
	
	# ignore inputs til host is ready for match settings
	if host_state != HostState.MATCH_SETTINGS:
		return
	
	if event.is_action_pressed("D-Pad Right"):
		next_game_mode()
	
	
	if event.is_action_pressed("D-Pad Left"):
	
		previous_game_mode()
	
	
	if event.is_action_pressed("D-Pad Up"):
	
		next_arena()
	
	if event.is_action_pressed("D-Pad Down"):
		previous_arena()
	
	
	if event.is_action_pressed("Start"):
	
		start_match()



# ------------------------
# Player joining
# ------------------------

func add_player(device_id : int):
	
	if host_id == -1:
		host_id = device_id

	for slot in player_slots:

		if slot.has_player() and slot.controller_id == device_id:

			return



	for slot in player_slots:

		if !slot.has_player():

			slot.join(device_id)

			if host_id == -1:
				host_id = device_id

			return


	print("Lobby full")

func player_has_joined(device_id : int) -> bool:

	for slot in player_slots:

		if slot.has_player():

			if slot.controller_id == device_id:

				return true


	return false


func get_host_slot() -> PlayerSlot:

	for slot in player_slots:

		if slot.has_player() and slot.controller_id == host_id:
			return slot
	return null


# ------------------------
# Buttons
# ------------------------

func _on_back_button_pressed() -> void: # this does not work per now

	get_tree().change_scene_to_file(
		"res://Menus/MainMenu/main_menu.tscn"
	)
