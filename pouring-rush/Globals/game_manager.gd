extends Node
## Game Manager



var MATCHSCENE = "res://MatchLogic/match_scene.tscn"
var MAINMENU = "res://main_menu/main_menu.tscn"


# Match variables
var match_config : MatchConfig

# settings variables
var music_volume : float = 1
var sfx_volume : float = 1
var fullscreen : bool = false


var winning_team : String # not being used

func load_main_menu():
	get_tree().change_scene_to_file(MAINMENU)

func start_match():
	get_tree().change_scene_to_file(MATCHSCENE)

func match_ended():
	print("going to end scene")
