extends State
class_name TechState

@export var idle_state : State
@export var fall_state : State

func on_enter():
	player.hurtbox.visible = false

func teching():
	await get_tree().create_timer(1).timeout
	if player.is_on_floor():
		next_state = idle_state
	else:
		next_state = fall_state


func on_exit():
	player.hurtbox.visible = true
