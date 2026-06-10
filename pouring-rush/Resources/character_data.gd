extends Resource
class_name CharacterData



@export var display_name : String
@export var player_scene : PackedScene

# physics
@export var acc : float = 40.0
@export var friction : float = 45.0
@export var air_acc : float = 30
@export var air_friction : float = 30
@export var jump_gravity : float = 800.0
@export var fall_gravity : float = 1000.0
@export var jump_hang_gravity : float = 10
@export var max_fall_velocity : float = 400.0
# jump
@export var jump_power : float = -360.0
# double jump
@export var double_jump_power : float = -360.0
# wall jump
@export var wall_jump_power : float = -300.0
@export var wall_jump_pushback : float = 360
# run speed
@export var run_speed : float = 185.0

# stats
@export_category("Stats")
@export var weight : float = 1

# Abilities
@export var basic_shot : AbilityData
@export var special_1 : AbilityData
@export var special_2 : AbilityData
@export var utility : AbilityData
