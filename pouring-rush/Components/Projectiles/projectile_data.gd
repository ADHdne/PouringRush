extends Resource
class_name ProjectileData


@export var hit_data : HitData

# texture and size and stuff
@export var texture : Texture
@export var radius : float = 8
@export var sprite_size : Vector2 = Vector2(1,1)
@export var sprite_rotation : float
@export var hit_sound : AudioStream
@export var hit_sound_volume : float

@export var gravity : float = 1000

@export var speed: float = 800
@export var lifetime: float = 2.0

@export var can_be_reflected: bool = true
@export var can_be_absorbed: bool = false

@export var pierces: int = 0

@export var ammo_cost: int = 1
