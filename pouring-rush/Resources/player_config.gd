extends Resource
class_name PlayerConfig


var character_data : CharacterData
var team : Team.type
var input_id : int
var color_index : int

var device : int
var ready : bool = false

var player_actions : Array[PlayerActions] = [
	preload("res://Characters/Player/PlayerResources/PlayerControls/player_1_actions.tres"),
	preload("res://Characters/Player/PlayerResources/PlayerControls/player_2_actions.tres"),
	preload("res://Characters/Player/PlayerResources/PlayerControls/player_3_actions.tres"),
	preload("res://Characters/Player/PlayerResources/PlayerControls/player_4_actions.tres"),
	preload("res://Characters/Player/PlayerResources/PlayerControls/player_5_actions.tres"),
	preload("res://Characters/Player/PlayerResources/PlayerControls/player_6_actions.tres"),
	preload("res://Characters/Player/PlayerResources/PlayerControls/player_7_actions.tres"),
	preload("res://Characters/Player/PlayerResources/PlayerControls/player_8_actions.tres"),
	]
