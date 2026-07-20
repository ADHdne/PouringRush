extends Resource
class_name AbilityData


enum AbilityType {
	PROJECTILE,
	UTILITY
}

enum UtilityType {
	NONE,
	DASH,
	TELEPORT,
	GRAPPLE,
	REFLECT
}

@export var shoot_shound : AudioStream
@export var shoot_sound_volume : float


@export var ability_type : AbilityType

@export var utility_type : UtilityType = UtilityType.NONE

@export var ability_name : String

# general cooldown between this shot and the next (whatever type it is)
@export var cooldown : float = 1.0

# cooldown for abilies
@export var ability_cooldown : float

# for projectiles
@export var max_ammo: int = 50
@export var reload_time : float = 1


@export var projectile_scene : PackedScene
@export var projectile_data : ProjectileData


## for utility
# dash
@export var dash_speed : float = 800
@export var dash_duration : float = 0.1

# teleport
@export var teleport_distance : float = 200
