extends State
class_name KOState

func on_enter():
	player.hurtbox.monitorable = false
	player.rotate(-90)
	print("hurtbox monitorable: ", player.hurtbox.monitorable)
	
	player.match_manager.on_player_ko(player)

func state_process(_delta):
	if player.hurtbox.monitorable == true:
		player.hurtbox.monitorable = false
