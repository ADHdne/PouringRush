extends CanvasLayer
class_name MatchUI


var match_manager : MatchManager

@export var player_icon_scene: PackedScene

@onready var h_box_container: HBoxContainer = $TeamPanel/HBoxContainer
@export var time_label : Label

@onready var progressbars: Control = $Progressbars
@onready var blue_bar: ProgressBar = $Progressbars/BlueBar
@onready var red_bar: ProgressBar = $Progressbars/RedBar
@onready var capture_bar: ProgressBar = $Progressbars/CaptureBar


@onready var end_scene: EndScreen = $EndScene


var team : Team.type

var pause_menu : PauseMenu

var player_icons: Dictionary = {}

func _ready() -> void:
	end_scene.visible = false

func initialize(players: Array[Player], match_manager : MatchManager, pause : PauseMenu):
	
	# reference to matchmanager
	self.match_manager = match_manager
	
	# reference to pause menu
	pause_menu = pause
	
	# getting players
	var team_players : Array[Player]
	
	for p in players:
		if p.team == team:
			team_players.append(p)
	
	clear_icons()

	if team_players != null:
		for player in team_players:
			var icon: PlayerIcon = player_icon_scene.instantiate()

			icon.setup(player)

			player_icons[player] = icon


			h_box_container.add_child(icon)
	

func _process(delta: float) -> void:
	
	if match_manager != null:
		if match_manager.match_in_progress:
			if not match_manager.game_mode.overtime:
				update_time(delta)

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


func update_time(delta):

	var time_left = match_manager.get_time_remaining()

	var total_seconds = int(ceil(time_left))

	var minutes = total_seconds / 60
	var seconds = total_seconds % 60

	time_label.text = "%02d:%02d" % [minutes, seconds]

func show_pause_menu(pause : PauseMenu):
	pause_menu = pause

func end_game(str : String):
	
	# hide non end scene
	pause_menu.hide()
	progressbars.hide()
	h_box_container.hide()
	
	end_scene.end_game(str)
	
	end_scene.show()

func deactivate_bars():
	capture_bar.visible = false
	
