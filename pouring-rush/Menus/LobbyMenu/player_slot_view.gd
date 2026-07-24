extends Control
class_name PlayerSlotView


@export var character_name_label : Label
@export var ready_label : Label
@export var controller_label : Label

@export var character_weapon_icon : TextureRect
@export var color_icon : TextureRect


var slot : PlayerSlot


func setup(new_slot:PlayerSlot):

	slot = new_slot

	slot.changed.connect(refresh)

	refresh()


func refresh():

	if slot == null:
		return

	if !slot.has_player():

		visible = false
		return

	visible = true

	var player = slot.player_config

	controller_label.text = "P" + str(slot.controller_id+1)

	character_name_label.text = player.character_data.display_name

	ready_label.text = (
		"READY"
		if player.ready
		else "NOT READY"
	)

	character_weapon_icon.texture = player.character_data.portrait

	update_color(player.color_index)


func update_color(id:int):

	var color := Color.WHITE

	match id:

		0: color = Color(0.4,0.8,0)
		1: color = Color(1,0.5,0)
		2: color = Color(1,0.3,0.3)
		3: color = Color(0.3,0.3,1)
		4: color = Color(0.5,0.5,0)
		5: color = Color(0.3,0.3,0.3)
		6: color = Color(0.7,0.7,0.7)
		7: color = Color(0.8,0,0.9)

	color_icon.modulate = color
