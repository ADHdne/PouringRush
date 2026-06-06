extends Resource
class_name HitData


@export var damage : float =  5
@export var healing : float = 0
@export var base_knockback : float = 0
@export var knockback_growth : float = 1
@export var knockback_type : KnockbackType
@export var hit_stun : float = 0
@export var direction : Vector2

enum KnockbackType {
	POKE, 
	LAUNCHER, 
	SPIKE
	}
