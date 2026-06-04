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


# player can action pressed
var can_action_pressed : bool = true

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	print("player jumps remain : ", movement.jumps_remaining)
