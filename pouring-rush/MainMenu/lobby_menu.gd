extends Control
class_name Lobby



## player list

@export var player_slots : Array[PlayerSlot]

var players : Array[PlayerConfig]

## match settings

var selected_stage := 0
var selected_game_mode := 0
