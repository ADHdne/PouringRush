extends State
class_name FallState


@export var move_state : State
@export var idle_state : State
@export var jump_state : State
@export var wall_slide_state : State

@export var coyote_timer : Timer


func state_process(_delta):
	if player.is_on_floor():
		if player.direction.x == 0:
			next_state = idle_state
		elif player.direction.x != 0:
			next_state = move_state
	elif player.is_on_wall() and player.velocity.y > 0:
		next_state = wall_slide_state

func state_input(event : InputEvent):
	if player.can_action_pressed:
		if event.is_action_pressed(player.input_handler.player_actions.jump):
			jump_pressed()
		# for picking up team zone
		if event.is_action_pressed(player.input_handler.player_actions.interact):
			interact()



## Button Presses
func jump_pressed():
	if not coyote_timer.is_stopped():
		_jump()
	elif player.movement_component.jumps_remaining > 0:
		double_jump()
	else:
		player.jump_buffer_timer.start()


func interact_button_pressed():
	if not player.can_action_pressed:
		return
	
	interact()


## Actions

func _jump():
	player.movement_component.jump()
	next_state = jump_state

func double_jump():
	player.movement_component.jumps_remaining -= 1
	# the physical jump
	player.velocity.y = player.character_data.double_jump_power
	next_state = jump_state


func interact():
	if player.carry_component.is_carrying():
		player.carry_component.drop()
	else:
		player.carry_component.pick_up(player.carry_component.zone)
