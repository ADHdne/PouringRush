extends Node
class_name LobbyManager


signal lobby_changed


@export var player_slots : Array[PlayerSlot]


const MAX_PLAYERS := 8


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


var selected_arena := 0
var selected_game_mode := 0


var host_id := -1
var host_state : HostState = HostState.PLAYER_SETUP



func _ready():

	for slot in player_slots:

		slot.lobby = self

		slot.player_joined.connect(refresh)
		slot.player_left.connect(refresh)
		slot.ready_changed.connect(refresh)
		slot.team_changed.connect(refresh)


	refresh()



# -------------------------
# Refresh
# -------------------------


func refresh():

	update_host_state()

	lobby_changed.emit()



# -------------------------
# Host
# -------------------------


func update_host_state():

	var host_slot := get_host_slot()

	if host_slot == null:
		return


	if host_slot.player_config.ready:
		host_state = HostState.MATCH_SETTINGS
	else:
		host_state = HostState.PLAYER_SETUP



func get_host_slot() -> PlayerSlot:

	for slot in player_slots:

		if slot.has_player():
			if slot.controller_id == host_id:
				return slot

	return null



# -------------------------
# Character lock
# -------------------------


func can_ready(slot:PlayerSlot) -> bool:


	for other in player_slots:


		if other == slot:
			continue


		if !other.has_player():
			continue


		if !other.player_config.ready:
			continue


		if other.player_config.team != slot.player_config.team:
			continue


		if other.player_config.character_data == slot.player_config.character_data:
			return false



	return true



# -------------------------
# Match settings
# -------------------------


func next_game_mode():

	selected_game_mode += 1

	if selected_game_mode >= game_modes.size():
		selected_game_mode = 0

	refresh()



func previous_game_mode():

	selected_game_mode -= 1

	if selected_game_mode < 0:
		selected_game_mode = game_modes.size()-1

	refresh()



func next_arena():

	selected_arena += 1

	if selected_arena >= arenas.size():
		selected_arena = 0

	refresh()



func previous_arena():

	selected_arena -= 1

	if selected_arena < 0:
		selected_arena = arenas.size()-1

	refresh()



func get_game_mode_name():

	return (
		game_modes[selected_game_mode]
		.resource_path
		.get_file()
		.get_basename()
	)



func get_arena_name():

	return (
		arenas[selected_arena]
		.resource_path
		.get_file()
		.get_basename()
	)



# -------------------------
# Joining
# -------------------------


func add_player(device_id:int):

	if player_has_joined(device_id):
		return


	for slot in player_slots:

		if !slot.has_player():

			slot.join(device_id)

			if host_id == -1:
				host_id = device_id

			return



func player_has_joined(device_id:int)->bool:


	for slot in player_slots:

		if slot.has_player():

			if slot.controller_id == device_id:
				return true


	return false



# -------------------------
# Start match
# -------------------------


func can_start_match()->bool:


	if host_state != HostState.MATCH_SETTINGS:
		return false


	var count := 0


	for slot in player_slots:


		if slot.has_player():

			count += 1


			if !slot.player_config.ready:
				return false



	return count >= 2




func start_match():

	if !can_start_match():
		return



	var config := MatchConfig.new()


	for slot in player_slots:

		if slot.has_player():

			config.players.append(slot.player_config)



	config.arena_scene = arenas[selected_arena]

	config.game_mode = game_modes[selected_game_mode]


	match selected_game_mode:

		0:
			config.game_mode_type = SelectedMode.Mode.STOCK

		1:
			config.game_mode_type = SelectedMode.Mode.PUSH

		2:
			config.game_mode_type = SelectedMode.Mode.CONTROL



	GameManager.match_config = config


	SoundManager.press_start.play()
	SoundManager.menu_music.stop()
	SoundManager.main_music.play()


	GameManager.start_match()
