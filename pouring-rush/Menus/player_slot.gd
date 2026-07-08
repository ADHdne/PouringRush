extends Control
class_name PlayerSlot


signal ready_changed()
signal player_joined()
signal player_left()

@export var character_name_label : Label
@export var team_label : Label
@export var ready_label : Label
@export var controller_label : Label
@export var portrait : TextureRect

@export var roster : Array[CharacterData]

var player_config : PlayerConfig

var joined := false
var controller_id := -1

var character_index := 0


func _ready():

	update_ui()




func _unhandled_input(event):

	if !has_player():
		return

	if event.device != controller_id:
		return


	if event.is_action_pressed("D-Pad Right"):
		next_character()


	if event.is_action_pressed("D-Pad Left"):
		previous_character()

	if event.is_action_pressed("D-Pad Down") or event.is_action_pressed("D-Pad Up"):
		swap_team()

	if event.is_action_pressed("Start"):
		toggle_ready()
		if event.device == 0:
			handle_lobby_settings()


func has_player() -> bool:
	return joined


func join(device_id : int):

	if joined:
		return

	joined = true
	controller_id = device_id

	player_config = PlayerConfig.new()
	player_config.device = device_id

	character_index = 0
	player_config.character_data = roster[character_index]
	player_config.team = Team.type.RED
	player_config.ready = false

	update_ui()

	player_joined.emit()


func leave():

	if !joined:
		return

	joined = false
	controller_id = -1
	player_config = null

	update_ui()

	player_left.emit()


func toggle_ready():

	if !joined:
		return

	player_config.ready = !player_config.ready

	update_ui()

	ready_changed.emit()


func next_character():

	if !joined:
		return

	if player_config.ready:
		return

	character_index += 1

	if character_index >= roster.size():
		character_index = 0

	player_config.character_data = roster[character_index]

	update_ui()


func previous_character():

	if !joined:
		return

	if player_config.ready:
		return

	character_index -= 1

	if character_index < 0:
		character_index = roster.size() - 1

	player_config.character_data = roster[character_index]

	update_ui()


func swap_team():

	if !joined:
		return

	if player_config.ready:
		return

	match player_config.team:

		Team.type.RED:
			player_config.team = Team.type.BLUE

		Team.type.BLUE:
			player_config.team = Team.type.RED

	update_ui()


func update_ui():

	if !joined:

		controller_label.text = "Press Start"
		character_name_label.text = "-"
		team_label.text = "-"
		ready_label.text = ""

		if portrait:
			portrait.texture = null

		return

	controller_label.text = "P" + str(controller_id + 1)

	character_name_label.text = player_config.character_data.display_name

	match player_config.team:

		Team.type.RED:
			team_label.text = "RED"

		Team.type.BLUE:
			team_label.text = "BLUE"

	if player_config.ready:
		ready_label.text = "READY"
	else:
		ready_label.text = "NOT READY"

	if portrait:
		portrait.texture = player_config.character_data.portrait

func handle_lobby_settings():
	pass
