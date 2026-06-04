extends Resource
class_name ProjectileData


@export var speed: float = 800
@export var damage: float = 5
@export var knockback: float = 300
@export var lifetime: float = 2.0

@export var can_be_reflected: bool = true
@export var can_be_absorbed: bool = false

@export var pierces: int = 0

@export var ammo_cost: int = 1

@export var role_tag: String = "dps"  # dps / tank / support
