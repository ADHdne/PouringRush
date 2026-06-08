extends State
class_name KOState

func on_enter():
	player.hurtbox.visible = false
	player.rotate(90)
