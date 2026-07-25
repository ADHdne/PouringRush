extends Control
class_name LobbyView


@export var red_team_container:GridContainer
@export var blue_team_container:GridContainer


@export var game_mode_label:Label
@export var arena_label:Label

@export var ready_label:Label
@export var start_label:Label


@export var player_slot_views:Array[PlayerSlotView]


var lobby : LobbyManager



func setup(manager:LobbyManager):

	lobby = manager

	lobby.lobby_changed.connect(refresh)

	refresh()



func refresh():

	if lobby == null:
		return


	update_settings()

	update_players()

	update_status()



# -------------------------
# Settings
# -------------------------


func update_settings():

	game_mode_label.text = lobby.get_game_mode_name()

	arena_label.text = lobby.get_arena_name()



# -------------------------
# Players
# -------------------------


func update_players():


	for i in player_slot_views.size():

		if i >= lobby.player_slots.size():
			continue


		var logic_slot = lobby.player_slots[i]


		player_slot_views[i].setup(logic_slot)


		if !logic_slot.has_player():
			continue


		match logic_slot.player_config.team:


			Team.type.RED:

				if player_slot_views[i].get_parent() != red_team_container:

					player_slot_views[i].reparent(red_team_container)



			Team.type.BLUE:

				if player_slot_views[i].get_parent() != blue_team_container:

					player_slot_views[i].reparent(blue_team_container)



# -------------------------
# Status
# -------------------------


func update_status():


	var count := 0


	for slot in lobby.player_slots:

		if slot.has_player():
			count += 1



	ready_label.text = str(count)+" Players Ready"



	if lobby.can_start_match():

		start_label.text = "Press Start"

	else:

		start_label.text = "Waiting..."
