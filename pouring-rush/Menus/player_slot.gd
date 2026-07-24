extends Control
class_name PlayerSlot


signal ready_changed()
signal player_joined()
signal player_left()
signal player_changed_team()



var lobby : Lobby

@export var character_name_label : Label
@export var ready_label : Label
@export var controller_label : Label
@export var portrait : TextureRect
@export var color_icon : TextureRect
var color_index : int = -1

@export var roster : Array[CharacterData]

var player_config : PlayerConfig

var joined := false
var controller_id := -1

var character_index := 0


func _ready():

	update_ui()




func _input(event):

	if !has_player():
		return

	if event.device != controller_id:
		return


	if event.is_action_pressed("D-Pad Up"):
		next_character()


	if event.is_action_pressed("D-Pad Down"):
		previous_character()

	if event.is_action_pressed("D-Pad Right") or event.is_action_pressed("D-Pad Left"):
		swap_team()
	
	if event.is_action_pressed("Reload"):
		color_index += 1
		if color_index >= 8:
			color_index = 0
		update_ui()

	if event.is_action_pressed("Start"):
		
		# host has moved to match settings
		if controller_id == lobby.host_id and player_config.ready:
			return
		
		toggle_ready()
		
		get_viewport().set_input_as_handled()


func has_player() -> bool:
	return joined


func join(device_id : int):

	if joined:
		return

	joined = true
	visible = true
	controller_id = device_id

	player_config = PlayerConfig.new()
	player_config.device = device_id
	
	# setting first character in rooster as hoovering or active
	character_index = 0
	
	player_config.character_data = roster[character_index]
	player_config.team = Team.type.RED
	player_config.ready = false
	
	# setting player color
	color_index = device_id
	
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
	
	player_changed_team.emit()
	update_ui()


func toggle_ready():

	if !joined:
		return
	
	# turn of ready if ready
	if player_config.ready:
		player_config.ready = false
	
	# can onnly ready if player is not taken
	else:
		if !lobby.can_ready(self):
			SoundManager.deny.play()
			return
		
		player_config.ready = true

	update_ui()

	ready_changed.emit()



func update_ui():

	if !joined:
		
		visible = false
		return

	controller_label.text = "P" + str(controller_id + 1)

	character_name_label.text = player_config.character_data.display_name

	if player_config.ready:
		ready_label.text = "READY"
	else:
		ready_label.text = "NOT READY"

	if portrait:
		portrait.texture = player_config.character_data.portrait
	
	# display character color
	set_color_icon(color_index)
	

func set_color_icon(id : int):
	var color : Color
	
	match id:
		0:
			color = Color(0.4,0.8,0)
		1:
			color = Color(1,0.5,0)
		2:
			color = Color(1,0.3,0.3)
		3:
			color = Color(0.3,0.3,1)
		4:
			color = Color(0.5,0.5,0)
		5:
			color = Color(0.3,0.3,0.3)
		6:
			color = Color(0.7,0.7,0.7)
		7:
			color = Color(0.8,0,0.9)
	
	color_icon.modulate = color
	
	# also updates character datas color index
	player_config.color_index = id
