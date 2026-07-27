extends Node
## Game Manager



var MATCHSCENE = "res://MatchLogic/match_scene.tscn"
var MAINMENU = "res://main_menu/main_menu.tscn"
var LOBBYSCENE = "res://Menus/LobbyMenu/lobby.tscn"
var VIEWSYSTEM = "res://Components/Viewport+/view_system.tscn"


var game_root : GameRoot



# Match variables
var match_config : MatchConfig

# settings variables
var music_volume : float = 1
var sfx_volume : float = 1
var fullscreen : bool = false


var winning_team : String # not being used

func load_main_menu():
	game_root.show_main_menu()

func load_lobby():
	game_root.show_lobby()

func start_match():
	game_root.start_match()

func match_ended():
	game_root.show_victory()

func return_to_lobby():
	
	game_root.return_to_lobby()
