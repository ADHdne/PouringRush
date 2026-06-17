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
		return
	
	if controlling_team == Team.type.RED:
		update_red_push()
	
	if controlling_team == Team.type.BLUE:
		update_blue_push()


func init(lane : PushLane, pusher : Pusher, red_barrier : PushBarrier, blue_barrier : PushBarrier):
	self.lane = lane
	self.pusher = pusher
	self.red_barrier = red_barrier
	self.blue_barrier = blue_barrier
	set_up_pusher()
	

func set_up_pusher():
	pusher.set_up(lane, red_barrier, blue_barrier)
	pusher.state = PusherStates.State.IDLE

func set_up_barriers():
	red_barrier.team = Team.type.RED
	blue_barrier.team = Team.type.BLUE
	
	red_barrier.progress = 0.60
	blue_barrier.progress = 0.40

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

func update_red_push():

	if pushing_red == true:
		pusher.state = PusherStates.State.TO_RED
	else:
		pusher.state = PusherStates.State.PUSH_RED


func update_blue_push():

	if pushing_blue == true:
		pusher.state = PusherStates.State.TO_BLUE
	else:
		pusher.state = PusherStates.State.PUSH_BLUE
