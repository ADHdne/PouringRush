extends Character
class_name Player


# reference to game logic
@export var match_manager : MatchManager


# reference to resources
@export var character_data : CharacterData



# reference to children
@export var player_sprite : Sprite2D
@export var gun_sprite : Sprite2D
@export var outline : Sprite2D
@export var gear : Sprite2D
@export var state_machine : CharacterStateMachine
@export var ko_state : State
@export var respawn_state : State
@export var reload_state : State

@export var coyote_jump_timer : Timer
@export var jump_buffer_timer : Timer
@export var footstep_timer : Timer

@export var sound_effects : CharacterSoundEffects

@export var input_handler : InputHandler

@export var movement_component : MovementComponent
@export var damage_component : DamageComponent
@export var knockback_component : KnockbackComponent
@export var combat_component : CombatComponent
@export var hurtbox : HurtboxComponent
@export var carry_component : CarryComponent

@export var tech_zone : Area2D

var player_index : int
var color : Color

# have a reference of what team its on during runtime
var team : Team.type

var spawn = SpawnPoint

# directions inputs
var direction = Vector2.ZERO
# aim directions inputs
var aim_direction = Vector2.ZERO

# player can do different actions
var can_action_pressed : bool = true
var can_jump : bool = true
var can_attack : bool = true
var can_tech : bool = false
var in_tumble : bool = false

# player states
var alive : bool = true

# facing bool
var facing_flipped : bool = false


# gear vars
var gear_ground_speed : float = 200
var gear_air_speed : float = 400




func _ready() -> void:
	# giving references to different things
	if hurtbox != null:
		hurtbox._owner = self
		hurtbox.damage_component = damage_component
		hurtbox.knockback_component = knockback_component
	
	if knockback_component != null:
		knockback_component.player = self
		knockback_component.damage_component = damage_component
	
	if damage_component != null:
		damage_component.player = self
	
	# setting up outline
	if team == Team.type.RED:
		outline.modulate = Color(0.7,0.2,0.2)
	else:
		outline.modulate = Color(0.2,0.2,0.7)

	

# match manager calles this
func initialize(character_data : CharacterData, match_manager : Node, device : int):
	self.character_data = character_data
	self.match_manager = match_manager
	
	input_handler.set_up(device, self, state_machine, combat_component)
	
	combat_component.initialize(character_data)
	carry_component.intialize(self)
	
	# setting gun sprite
	gun_sprite.texture = character_data.portrait



func _process(delta: float) -> void:
	
	if not match_manager.match_in_progress:
		can_action_pressed = false
	
	# flip player based on direction
	if direction.x > 0 and facing_flipped:
		flip_sprite(false)
	elif direction.x < 0 and not facing_flipped:
		flip_sprite(true)
	
	direction = input_handler.movement_direction
	aim_direction = input_handler.aim_direction
	
	
	rotate_gun(aim_direction)
	
	if is_on_floor():
		rotate_gear(delta, gear_ground_speed)
	else:
		rotate_gear(delta, gear_air_speed)


func reset_for_respawn():
	combat_component.reset_for_spawn(character_data)
	state_machine.current_state.next_state = respawn_state
	hurtbox.monitorable = true
	damage_component.percentage = 0

func hit_visual():
	sprite.modulate = Color(1,1,1)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = color

func ko():
	alive = false
	state_machine.on_state_interupt_state(ko_state)
	hurtbox.monitorable = false
	can_action_pressed = false

func set_color(color_index : int):
	
	match color_index:
		0:
			color = Color(0.4,0.8,0)
		1:
			color = Color(1,0.5,0)
		2:
			color = Color(1,0.3,0.3)
		3:
			color = Color(0.3,0.3,1)
		4:
			color = Color(0.5,0.5,0)
		5:
			color = Color(0.3,0.3,0.3)
		6:
			color = Color(0.7,0.7,0.7)
		7:
			color = Color(0.8,0,0.9)
	sprite.modulate = color


func _on_alive_timer_timeout() -> void:
	alive = true
	hurtbox.monitorable = true
	can_action_pressed = true

func flip_sprite(flipped : bool):
	if not flipped:
		player_sprite.flip_h = false
		sprite.flip_h = false # player color
		gear.flip_h = false
		outline.flip_h = false
		# a flipped bool
		facing_flipped = false
		
	else:
		player_sprite.flip_h = true
		sprite.flip_h = true # player color
		gear.flip_h = true
		outline.flip_h = true
		
		facing_flipped = true

func rotate_gear(delta : float, speed : float):
	if direction.x == 0:
		return
	
	if direction.x > 0:
		gear.rotation_degrees += speed * delta
	else:
		gear.rotation_degrees -= speed * delta

func rotate_gun(_aim_direction : Vector2):
	if aim_direction == Vector2(0, 0):
		if not facing_flipped:
			gun_sprite.rotation_degrees = 45
		else:
			gun_sprite.rotation_degrees = -135
		return
	
	elif aim_direction.length() > 0.2:
		gun_sprite.rotation = _aim_direction.angle() + deg_to_rad(45) 


func set_controls():
	pass
