extends GameMode
class_name ControlMode


@onready var control_timer: Timer = $ControlTimer

var red_ui : MatchUI
var blue_ui : MatchUI


var control_zone : ControlZone

var taking_control : Team.type

var control_time : float = 5


var red_score : float
var blue_score : float

var winning_amount : int = 5 #420

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	
	if not match_in_progress:
		return
	
	super._physics_process(delta)
	
	
	if control_zone.owner_team == Team.type.RED:
		red_score += delta

	elif control_zone.owner_team == Team.type.BLUE:
		blue_score += delta
	
	# setting the ui bars to the right score
	red_ui.red_bar.value = red_score
	red_ui.blue_bar.value = blue_score
	
	blue_ui.red_bar.value = red_score
	blue_ui.blue_bar.value = blue_score
	
	red_ui.capture_bar.value = control_zone.capture_progress
	blue_ui.capture_bar.value = control_zone.capture_progress

	if red_score >= winning_amount:
		check_overtime(Team.type.RED)
	if blue_score >= winning_amount:
		check_overtime(Team.type.BLUE)
	


func init(control_zone : ControlZone, view_system : ViewSystem):
	self.control_zone = control_zone
	red_ui = view_system.red_match_ui
	blue_ui = view_system.blue_match_ui
	set_progress_bars()



func set_progress_bars():
	red_ui.red_bar.max_value = winning_amount
	red_ui.blue_bar.max_value = winning_amount
	
	blue_ui.red_bar.max_value = winning_amount
	blue_ui.blue_bar.max_value = winning_amount
	
	red_ui.capture_bar.max_value = 1
	blue_ui.capture_bar.max_value = 1

func leading_team() -> Team.type:
	if red_score > blue_score:
		return Team.type.RED
	else: 
		return Team.type.BLUE

func check_overtime(team : Team.type):
	match team:
		Team.type.RED:
			if control_zone.blue_count <= 0:
				end_match("Victory for the Red Team")
				match_manager.end_match()
		Team.type.BLUE:
			if control_zone.red_count <= 0:
				end_match("Victory for the Blue Team")
				match_manager.end_match()

func match_timer_timeout():
	check_overtime(leading_team())
