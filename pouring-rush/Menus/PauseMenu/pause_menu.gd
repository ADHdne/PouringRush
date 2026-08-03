extends Control
class_name PauseMenu

@export var animation : AnimationPlayer

@export var resume_button : Button
@export var objective_button : Button
@export var quit_button : Button

@export var selected_color := Color.WHITE
@export var normal_color := Color(0.7,0.7,0.7)

var buttons : Array[Button]


func _ready():

	buttons = [
		resume_button,
		objective_button,
		quit_button
	]

	hide()

	animation.play("RESET")


func show_menu():

	show()
	move_to_front()
	animation.play("Blur")


func hide_menu():

	hide()


func set_selection(index:int):

	for i in buttons.size():

		buttons[i].modulate = normal_color

	buttons[index].modulate = selected_color
