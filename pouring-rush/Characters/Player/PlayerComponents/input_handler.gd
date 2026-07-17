extends Node
class_name InputHandler


@export var player_actions : PlayerActions


var controller_id : int = -1

func set_up(device_id : int):
	controller_id = device_id


func check_controller(action : StringName) -> bool:
	for event in InputMap.action_get_events(action):
		if event.device == controller_id:
			return Input.is_action_pressed(action)
	return false
