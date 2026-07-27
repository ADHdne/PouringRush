extends Node
class_name GameRoot


@export var main_menu : Control
@export var view_system : ViewSystem
@export var current_game : Node


func _ready():

	
	show_main_menu()



func show_main_menu():

	main_menu.show()

	view_system.show_main_menu()



func show_lobby():

	main_menu.hide()

	view_system.show_lobby()



func start_match(match_scene : PackedScene):

	for child in current_game.get_children():
		child.queue_free()


	var match_instance = match_scene.instantiate()

	current_game.add_child(match_instance)


	view_system.show_match()



func show_victory():

	view_system.show_victory()
