extends Node
class_name PauseController


signal quit_to_lobby


@export var red_menu : PauseMenu
@export var blue_menu : PauseMenu


enum Option {
	RESUME,
	OBJECTIVE,
	QUIT
}


var paused := false
var selection := Option.RESUME


func _ready():

	red_menu.hide_menu()
	blue_menu.hide_menu()


func toggle():

	if paused:
		resume()
	else:
		pause()


func pause():

	if paused:
		return

	paused = true

	get_tree().paused = true

	selection = Option.RESUME

	red_menu.show_menu()
	blue_menu.show_menu()

	update_visuals()

	SoundManager.menu_open.play()


func resume():

	if !paused:
		return

	paused = false

	get_tree().paused = false

	red_menu.hide_menu()
	blue_menu.hide_menu()

	SoundManager.menu_close.play()


func _input(event):
	if GameManager.current_state != GameManager.State.MATCH:
		return
	
	if !paused:
		return

	if event.is_action_pressed("D-Pad Down"):
		selection += 1

		if selection > 2:
			selection = 0

		update_visuals()

		SoundManager.button.play()

		get_viewport().set_input_as_handled()


	elif event.is_action_pressed("D-Pad Up"):

		selection -= 1

		if selection < 0:
			selection = 2

		update_visuals()

		SoundManager.button.play()

		get_viewport().set_input_as_handled()


	elif event.is_action_pressed("Utility"):

		activate()

		get_viewport().set_input_as_handled()


func update_visuals():

	red_menu.set_selection(selection)
	blue_menu.set_selection(selection)


func activate():

	match selection:

		Option.RESUME:

			resume()

		Option.OBJECTIVE:

			print("Objective")

		Option.QUIT:

			resume()

			# stop clock ticks sound if playing
			SoundManager.clock_tick_fast.stop()
			SoundManager.clock_tick_slow.stop()
			
			SoundManager.main_music.stop()
			SoundManager.deny.play()
			
			await get_tree().create_timer(0.20).timeout
			GameManager.return_to_lobby()
