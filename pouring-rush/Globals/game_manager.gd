extends Node
## Game Manager



var MATCHSCENE = "res://MatchLogic/match_scene.tscn"
var MAINMENU = "res://main_menu/main_menu.tscn"
var ENDSCENE = "res://EndScene/EndScene.tscn"


# Match variables
var match_config : MatchConfig

# settings variables
var music_volume : float = 1
var sfx_volume : float = 1
var fullscreen : bool = false


# a verry simple endscreen
var winning_team : String

func load_main_menu():
	get_tree().change_scene_to_file(MAINMENU)

func start_match():
	get_tree().change_scene_to_file(MATCHSCENE)

func match_ended():
	get_tree().change_scene_to_file(ENDSCENE)
