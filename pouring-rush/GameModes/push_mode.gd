extends GameMode
class_name PushMode

# how many players from each team in range
var red_count : = 0
var blue_count : = 0


func _physics_process(delta: float) -> void:
	super._physics_process(delta)



func get_control_state() -> int:
	if red_count > 0 and blue_count == 0:
		return 1
	
	if blue_count > 0 and red_count == 0:
		return -1
	
	return 0 # if contested or empty



# now i need to make the bot and objectives
# on the bots range area:
#func _on_player_enter(team):
#
	#if team == Team.type.RED:
		#red_count += 1
	#else:
		#blue_count += 1
#
#
#func _on_player_exit(team):
#
	#if team == Team.type.RED:
		#red_count -= 1
	#else:
		#blue_count -= 1
