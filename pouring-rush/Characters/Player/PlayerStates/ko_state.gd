extends State
class_name KOState

func on_enter():
	player.hurtbox.monitorable = false
	player.rotate(-90)
	print("hurtbox monitorable: ", player.hurtbox.monitorable)

func state_process(_delta):
	if player.hurtbox.monitorable == true:
		player.hurtbox.monitorable = false
