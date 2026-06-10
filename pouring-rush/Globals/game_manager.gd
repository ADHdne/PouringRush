extends Node
## Game Manager



var MATCHSCENE = "res://MatchLogic/match_scene.tscn"
var MAINMENU = "res://main_menu/main_menu.tscn"


# match variables
var selected_arena : PackedScene
var selected_game_mode : PackedScene
var selected_characters : Array = [CharacterData]
var match_config : MatchConfig

# settings variables
var music_volume : float = 1
var sfx_volume : float = 1
var fullscreen : bool = false

func load_main_menu():
	get_tree().change_scene_to_file(MAINMENU)

func start_match():
	get_tree().change_scene_to_file(MATCHSCENE)
