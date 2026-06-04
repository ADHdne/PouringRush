extends Character
class_name Player


# reference to resources
@export var properties : CharacterProperties
@export var player_actions : PlayerActions

# reference to children
@export var state_machine : CharacterStateMachine
@export var coyote_jump_timer : Timer
@export var footstep_timer : Timer
@export var sound_effects : CharacterSoundEffects
@export var movement : MovementComponent

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	print("player on floor: ", is_on_floor(), " ", movement.direction)
