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

# can event action pressed
var can_action_pressed : bool = true

## dash vars
var dash_timer = 0

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	## add gravity
	if not is_on_floor():
		## jump gravity
		if velocity.y < -0.1:
			velocity.y += properties.jump_gravity * delta
		## gravity at jumps peak
		elif velocity.y > -0.1 and velocity.y < 0.1:
			velocity.y += properties.jump_hang_gravity * delta
		## fall gravity
		else:
			velocity.y += properties.fall_gravity * delta
		## max fall velocity
		if velocity.y > properties.max_fall_velocity:
			velocity.y = properties.max_fall_velocity
	
	if direction.x != 0 and state_machine.check_if_can_move() and can_action_pressed:
		accelerate(direction.x)
		if is_on_floor():
			if footstep_timer.time_left <= 0:
				sound_effects.run()
				footstep_timer.start(0.15)
	else:
		add_friction()
	
	# dash timer
	if dash_timer > 0:
		dash_timer -= delta

	player_movement()
	update_facing_direction()
	input()

func input() -> Vector2:
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	direction = direction.normalized()
	return direction

func accelerate(direction):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, properties.run_speed * direction, properties.acc)
	else:
		velocity.x = move_toward(velocity.x, properties.run_speed * direction, properties.air_acc)

func add_friction():
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, properties.friction)
	else:
		velocity.x = move_toward(velocity.x, 0, properties.air_friction)
	
func player_movement():
	var was_on_the_flore = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_the_flore and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()
