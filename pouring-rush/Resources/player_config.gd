extends Resource
class_name PlayerConfig


var character_data : CharacterData
var team : Team.type
var input_id : int
var player_actions : Array[PlayerActions] = [
	preload("res://Characters/Player/PlayerResources/PlayerControls/player_1_actions.tres"),
	preload("res://Characters/Player/PlayerResources/PlayerControls/player_2_actions.tres")
	]
