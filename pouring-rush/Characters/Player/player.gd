extends Character
class_name Player


# reference to game logic
var match_manager : MatchManager


# reference to resources
@export var character_data : CharacterData
@export var properties : CharacterProperties
@export var player_actions : PlayerActions
@export var stats : Stats




# reference to children
@export var state_machine : CharacterStateMachine

@export var coyote_jump_timer : Timer
@export var jump_buffer_timer : Timer
@export var footstep_timer : Timer

@export var sound_effects : CharacterSoundEffects

@export var movement : MovementComponent
@export var damage_component : DamageComponent
@export var knockback_component : KnockbackComponent
@export var hurtbox : HurtboxComponent
@export var KO_component : KOComponent

@export var tech_zone : Area2D

@export var wall_collision_check : KOCollisionCheck
@export var ceiling_collision_check : KOCollisionCheck


# directions inputs
var direction = Vector2.ZERO
# aim directions inputs
var aim_direction = Vector2.ZERO

# player can do different actions
var can_action_pressed : bool = true
var can_jump : bool = true
var can_attack : bool = true

var facing_flipped : bool = false

var can_tech : bool = false


func _ready() -> void:
	# giving references to different things
	if hurtbox != null:
		hurtbox._owner = self
		hurtbox.damage_component = damage_component
		hurtbox.knockback_component = knockback_component
	
	if knockback_component != null:
		knockback_component.player = self
		knockback_component.damage_component = damage_component
	
	if KO_component != null:
		KO_component.player = self


func _process(delta: float) -> void:
	
	# flip player based on direction
	if direction.x > 0 and facing_flipped:
		facing_flipped = false
	elif direction.x < 0 and not facing_flipped:
		facing_flipped = true
	
	input()

func input() -> Vector2:
	direction = Input.get_vector(player_actions.move_left, player_actions.move_right, player_actions.move_up, player_actions.move_down)
	direction = direction.normalized()
	return direction

func aim_input() -> Vector2:
	aim_direction = Input.get_vector(player_actions.aim_left, player_actions.aim_right, player_actions.aim_up, player_actions.aim_down)
	aim_direction = aim_direction.normalized()
	return aim_direction
