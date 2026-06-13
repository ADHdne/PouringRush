extends GameMode
class_name StockMode



var stocks := {}


#func start_match():
	#for p in players:
		#stocks[p] = 3



#func on_player_ko(player : Player):
	#
	#stocks[player] -= 1
	#
	#if stocks[player] > 0:
		#match_manager.respawn_player(player)
	#else:
		#player.queue_free()
	#
	#check_win_condition()

func check_win_condition():
	
	var alive := []
	
	for p in players:
		if stocks[p] > 0:
			alive.append(p)
	
	if alive.size() <= 1:
		end_match()
