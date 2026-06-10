extends Resource
class_name CharacterProperties


@export_category("Properties")
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
# wall slide gravity
@export var wall_slide_grav : float = 40

@export_category("Stats")
# stat values
@export var poise : float

@export_group("Dash Stats")
# dash stats
@export var dash_speed = 700
@export var dash_max_distance = 115
@export var dash_curve : Curve
@export var dash_cooldown : float = 1.0
