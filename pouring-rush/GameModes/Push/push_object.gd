extends PathFollow2D
class_name PushObject



func move_along_path(speed : float, delta : float):
	progress += speed * delta
