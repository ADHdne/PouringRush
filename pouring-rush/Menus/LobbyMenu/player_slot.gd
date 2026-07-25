extends Node
class_name PlayerSlot


signal changed
signal player_joined
signal player_left
signal ready_changed
signal team_changed


var lobby : LobbyManager

var player_config : PlayerConfig


var joined := false
var controller_id := -1


var character_index := 0
var color_index := 0


@export var roster : Array[CharacterData]



func has_player() -> bool:
	return joined



func join(device_id:int):

	if joined:
		return


	joined = true
	controller_id = device_id


	player_config = PlayerConfig.new()

	player_config.device = device_id
	player_config.team = Team.type.RED
	player_config.ready = false


	character_index = 0

	color_index = device_id


	player_config.character_data = roster[character_index]
	player_config.color_index = color_index


	player_joined.emit()
	changed.emit()



func leave():

	if !joined:
		return


	joined = false

	controller_id = -1

	player_config = null


	player_left.emit()
	changed.emit()



# --------------------
# Character
# --------------------


func next_character():

	if !joined:
		return

	if player_config.ready:
		return


	character_index += 1

	if character_index >= roster.size():
		character_index = 0


	player_config.character_data = roster[character_index]

	changed.emit()



func previous_character():

	if !joined:
		return

	if player_config.ready:
		return


	character_index -= 1

	if character_index < 0:
		character_index = roster.size()-1


	player_config.character_data = roster[character_index]

	changed.emit()



# --------------------
# Team
# --------------------


func swap_team():

	if !joined:
		return

	if player_config.ready:
		return


	if player_config.team == Team.type.RED:

		player_config.team = Team.type.BLUE

	else:

		player_config.team = Team.type.RED


	team_changed.emit()
	changed.emit()



# --------------------
# Ready
# --------------------


func toggle_ready():

	if !joined:
		return



	if player_config.ready:

		player_config.ready = false


	else:

		if !lobby.can_ready(self):

			SoundManager.deny.play()
			return


		player_config.ready = true



	ready_changed.emit()
	changed.emit()


# --------------------
# Input
# --------------------

func _input(event):

	if !has_player():
		return

	if event.device != controller_id:
		return

	if event.is_action_pressed("D-Pad Right"):
		swap_team()

	if event.is_action_pressed("D-Pad Up"):
		next_character()

	if event.is_action_pressed("Start"):
		toggle_ready()
