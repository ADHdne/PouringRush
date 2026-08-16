extends State
class_name RevivingState


@export var idle_state : IdleState


@export var revive_component : ReviveComponent
@export var alive_timer : Timer


func on_enter():
	alive_timer.start()



func _on_revive_timer_timeout() -> void:
	next_state = idle_state
