extends GameMode
class_name PushMode



# how many players from each team in range
var red_players_near : = 0
var blue_players_near : = 0


var pusher: Pusher 

var red_barrier: PushBarrier 
var blue_barrier: PushBarrier

var pushing_red : bool = false
var pushing_blue : bool = false

var lane : PushLane

func _ready() -> void:
	
	super()
	
	SignalBus.evaluate_control.connect(get_controlling_team)
	SignalBus.pushing_barrier.connect(pushing_barrrier)
	SignalBus.stopped_pushing_barrier.connect(stopped_pushing)
	


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	var controlling_team = set_control_state()
	
	if controlling_team == null:
		stop()
	
	if controlling_team == Team.type.RED:
		update_red_push()
	
	if controlling_team == Team.type.BLUE:
		update_blue_push()
	
	check_win_condition()
	
	if overtime:
		if controlling_team == null:
			if overtime_timer.is_stopped():
				overtime_timer.start(3)
		else:
			overtime_timer.stop()
	
	if match_manager.match_timer.time_left <= 30 and not SoundManager.clock_tick_slow.playing:
		SoundManager.clock_tick_slow.play()
	if overtime and not SoundManager.clock_tick_fast.playing:
		SoundManager.clock_tick_fast.play()
		


func init(lane : PushLane, pusher : Pusher, red_barrier : PushBarrier, blue_barrier : PushBarrier):
	self.lane = lane
	self.pusher = pusher
	self.red_barrier = red_barrier
	self.blue_barrier = blue_barrier
	set_up_barriers()
	set_up_pusher()
	

func set_up_pusher():
	pusher.set_up(lane, red_barrier, blue_barrier)
	pusher.state = PusherStates.State.IDLE

func set_up_barriers():
	red_barrier.team = Team.type.RED
	blue_barrier.team = Team.type.BLUE
	
	red_barrier.set_color()
	blue_barrier.set_color()

# Durring match

func start_match():
	
	super()
	pusher.progress = lane.get_length() / 2
	red_barrier.progress = lane.get_length() / 10 * 6
	blue_barrier.progress = lane.get_length() / 10 * 4

func get_controlling_team():
	red_players_near = pusher.red_count
	blue_players_near = pusher.blue_count
	

func set_control_state():
	if red_players_near > 0 and blue_players_near == 0:
		return Team.type.RED
	
	if blue_players_near > 0 and red_players_near == 0:
		return Team.type.BLUE
	
	return null # if contested or empty

func pushing_barrrier(team : Team.type):
	
	
	if team == null:
		pushing_red = false
		pushing_blue = false
	
	if team == Team.type.RED:
		pushing_red = true
		pushing_blue = false
	if team == Team.type.BLUE:
		pushing_red = false
		pushing_blue = true
	


func stopped_pushing():
	pushing_red = false
	pushing_blue = false
	
	if overtime:
		determine_winner_on_timeout()
		overtime = false

func stop():
	pusher.state = PusherStates.State.IDLE

func update_red_push():
	if not pushing_red:
		pusher.state = PusherStates.State.TO_RED
	else:
		pusher.state = PusherStates.State.PUSH_RED


func update_blue_push():
	if not pushing_blue:
		pusher.state = PusherStates.State.TO_BLUE
	else:
		pusher.state = PusherStates.State.PUSH_BLUE

func determine_winner_on_timeout():

	var red_distance = red_barrier.progress
	var blue_distance = lane.get_length() - blue_barrier.progress

	if red_distance > blue_distance:
		on_team_wins(Team.type.RED)

	elif blue_distance > red_distance:
		on_team_wins(Team.type.BLUE)

	else:
		on_draw()

func check_win_condition():
	if match_in_progress == true:
		if red_barrier.progress >= lane.get_length():
			on_team_wins(Team.type.RED)
		if blue_barrier.progress <= 0:
			blue_team_wins = true
			on_team_wins(Team.type.BLUE)
		else:
			return

func on_team_wins(team : Team.type):
	match team:
		Team.type.RED:
			red_team_wins = true
			end_match("Victory for the Red Team")
		Team.type.BLUE:
			blue_team_wins = true
			end_match("Victory for the Blue Team")
	match_manager.end_match()

func on_draw():
	end_match("Draw: No Winning Team")
	match_manager.end_match()


func match_timer_timeout():
	check_overtime()

func check_overtime():
	if pushing_blue or pushing_red:
		overtime = true
		
		# stopping the overtime timer
		overtime_timer.stop()
		
		# setting time label to overtime
		match_manager.view_system.red_match_ui.time_label.text = " Overtime"
		match_manager.view_system.blue_match_ui.time_label.text = "Overtime"


func _on_overtime_timer_timeout() -> void:
	determine_winner_on_timeout()
