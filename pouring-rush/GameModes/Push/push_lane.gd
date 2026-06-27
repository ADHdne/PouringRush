extends Path2D
class_name PushLane

@onready var pusher: Pusher = $Pusher
@onready var red_barrier: PushBarrier = $RedBarrier
@onready var blue_barrier: PushBarrier = $BlueBarrier


func get_length() -> float:
	return curve.get_baked_length()

func deactivate():
	visible = false
