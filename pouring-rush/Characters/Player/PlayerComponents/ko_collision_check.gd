extends Area2D
class_name KOCollisionCheck


@export var collision_speed : float
@export var player : Player


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ground"):
		collision_speed = player.KO_component.get_speed()
