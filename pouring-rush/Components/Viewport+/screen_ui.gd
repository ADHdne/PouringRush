extends Control
class_name ScreenUI


@export var match_ui : MatchUI
@export var lobby_view : LobbyView


func show_lobby():
	lobby_view.show()
	match_ui.hide()


func show_match():
	match_ui.show()
	lobby_view.hide()
