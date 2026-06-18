extends State
class_name KOState

func on_enter():
	player.hurtbox.monitorable = false
	player.can_action_pressed = false
	player.rotate(-90)

func state_process(_delta):
	if player.hurtbox.monitorable == true:
		player.hurtbox.monitorable = false


func on_exit():
	player.rotate(90)
