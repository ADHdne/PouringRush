extends Node
class_name InputHandler




@export var player_actions : PlayerActions

@export var player : Player

var controller_id : int = -1

func set_up(device_id : int, player : Player):
	controller_id = device_id
	self.player = player


func check_controller(action : StringName) -> bool:
	for event in InputMap.action_get_events(action):
		if event.device == controller_id:
			return Input.is_action_pressed(action)
	return false

func _unhandled_input(event: InputEvent) -> void:
	if event.device != controller_id:
		return
	
	
