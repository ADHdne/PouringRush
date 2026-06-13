extends Node
class_name State


@export var can_move : bool = true
@export var can_reload : bool = true

var player : Player
var playback : AnimationNodeStateMachinePlayback
var next_state : State

@warning_ignore("unused_signal")
signal interupt_state(new_state : State)

func state_process(_delta):
	pass

func state_input(event : InputEvent):
	pass

func on_enter():
	pass

func on_exit():
	pass
