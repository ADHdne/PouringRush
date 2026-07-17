extends Node
class_name InputHandler


@export var player_actions : PlayerActions


var controller_id : int = -1

func set_up(device_id : int):
	controller_id = device_id



func _unhandled_input(event: InputEvent) -> void:
	check_controller(event)

func check_controller(event : InputEvent) -> void:
	if event.device != controller_id:
		return
	
	if event.is_action_pressed("Jump"):
		
			if event.device == controller_id:
				print("controller id: ", controller_id)
