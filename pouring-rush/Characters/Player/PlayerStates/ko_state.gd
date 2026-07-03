extends State
class_name KOState

func on_enter():
	player.rotate(-90)
	
	# play sound
	player.sound_effects.ko()


func on_exit():
	player.rotate(90)
