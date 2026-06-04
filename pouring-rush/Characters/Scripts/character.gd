extends CharacterBody2D
class_name Character

## signal for if character flips
signal facing_direction_changed(facing_right : bool)

@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D

var can_flip : bool = true

#func update_facing_direction():
	#if can_flip == true:
		#if is_on_floor() or is_on_wall_only():
			#if direction.x > 0:
				#sprite.flip_h = false # add facing directions as boolians
			#elif direction.x < 0:
				#sprite.flip_h = true
