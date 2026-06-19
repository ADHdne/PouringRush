extends CanvasLayer
class_name MatchUI



@export var player_icon_scene: PackedScene

@onready var h_box_container: HBoxContainer = $TeamPanel/HBoxContainer


var team : Team.type


var player_icons: Dictionary = {}



func initialize(players: Array[Player]):
	
	var team_players : Array[Player]
	
	for p in players:
		if p.team == team:
			team_players.append(p)
	
	clear_icons()

	if team_players != null:
		for player in team_players:
			print("player")
			var icon: PlayerIcon = player_icon_scene.instantiate()

			icon.setup(player)

			player_icons[player] = icon


			h_box_container.add_child(icon)



func clear_icons():

	for icon in player_icons.values():

		if is_instance_valid(icon):
			icon.queue_free()

	player_icons.clear()


func get_icon(player: Player) -> PlayerIcon:

	if player_icons.has(player):
		return player_icons[player]

	return null

func remove_player(player: Player):

	if not player_icons.has(player):
		return

	var icon = player_icons[player]

	if is_instance_valid(icon):
		icon.queue_free()

	player_icons.erase(player)
