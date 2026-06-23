extends Node2D
class_name CharacterSoundEffects



@export var dash_sound : AudioStreamPlayer2D
@export var hit_sound : AudioStreamPlayer2D
@export var hit_rock_sound : AudioStreamPlayer2D
@export var glass_break_sound : AudioStreamPlayer2D
@export var splatt_sound : AudioStreamPlayer2D
@export var footstep_sound : AudioStreamPlayer2D
@export var jumpswoosh_sound : AudioStreamPlayer2D




func run():
	footstep_sound.pitch_scale = randf_range(1, 1.4)
	footstep_sound.play()


func jump():
	jumpswoosh_sound.pitch_scale = randf_range(1.2, 1.6)
	jumpswoosh_sound.play()


func hit():
	hit_sound.play()
	splatt_sound.play()

func dash():
	dash_sound.pitch_scale = randf_range(0.8, 1.2)
	dash_sound.play(0.11)


func ko():
	hit_rock_sound.play()
	glass_break_sound.play()
