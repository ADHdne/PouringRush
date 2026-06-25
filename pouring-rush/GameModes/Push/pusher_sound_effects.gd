extends Node2D
class_name PusherSoundEffects




@export var pushing_sound : AudioStreamPlayer2D
@export var walking_sound : AudioStreamPlayer2D



func push():
	pushing_sound.pitch_scale = randf_range(0.8, 1.2)
	pushing_sound.play()

func walk():
	walking_sound.pitch_scale = randf_range(0.6, 1)
	walking_sound.play()
