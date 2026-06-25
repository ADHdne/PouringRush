extends State
class_name PickupState


@export var idle_state : State

@export var lag : float = 0.5

func on_enter():
	player.sound_effects.pick_up()
	await get_tree().create_timer(lag).timeout
	next_state = idle_state
