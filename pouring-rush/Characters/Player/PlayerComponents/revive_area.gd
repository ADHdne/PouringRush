extends Area2D
class_name ReviveArea

var candidates : Array[Player]

func _on_body_entered(body):

	if body is Player:
		candidates.append(body)


func _on_body_exited(body):

	candidates.erase(body)
