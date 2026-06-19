extends CharacterBody2D
class_name Character

## signal for if character flips
signal facing_direction_changed(facing_right : bool)

@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D
