extends GameMode
class_name ControlMode



var control_zone : ControlZone


func init(control_zone : ControlZone):
	self.control_zone = control_zone





func _on_overtime_timer_timeout() -> void:
	pass
