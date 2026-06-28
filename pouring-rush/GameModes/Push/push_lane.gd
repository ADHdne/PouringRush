extends Path2D
class_name PushLane

@onready var pusher: Pusher = $Pusher
@onready var red_barrier: PushBarrier = $RedBarrier
@onready var blue_barrier: PushBarrier = $BlueBarrier

var red_start_progress
var blue_start_progress

func get_length() -> float:
	return curve.get_baked_length()

func deactivate():
	visible = false

func set_progress():
	red_start_progress = get_length() / 10 * 6
	blue_start_progress = get_length() / 10 * 4
