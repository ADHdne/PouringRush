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
	GRAPPLE
}



@export var ability_type : AbilityType

@export var Utility_type : UtilityType = UtilityType.NONE

@export var ability_name : String

# general cooldown between this shot and the next (whatever type it is)
@export var cooldown : float = 1.0

# cooldown for abilies
@export var ability_cooldown : float
@export var max_ammo: int = 50
@export var reload_time : float = 1


@export var projectile_scene : PackedScene
@export var projectile_data : ProjectileData
