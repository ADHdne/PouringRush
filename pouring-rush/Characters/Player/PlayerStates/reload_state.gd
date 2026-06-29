extends State
class_name ReloadState


@export var idle_state : State
@export var reload_timer : Timer



func on_enter():
	player.can_attack = false
	reload_timer.start(player.combat_component.basic_shot_data.ability_data.reload_time)
	
	# playes reload sound
	player.sound_effects.reload()
	
	# make the player slightly see through when reloading
	# This should be an animation
	player.sprite.modulate -= Color(0, 0, 0, 0.3)

func on_exit():
	player.can_attack = true


func _on_reload_timer_timeout() -> void:
	next_state = idle_state
	
	player.sprite.modulate = player.color
