extends Node2D
class_name World


@onready var arena_root: Node2D = $ArenaRoot
@onready var players_root: Node2D = $PlayersRoot
@onready var game_mode_root: Node = $GameModeRoot
@export var team_camera : TeamCamera
