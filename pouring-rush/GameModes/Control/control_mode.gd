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

var winning_amount : int = 5

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if control_zone.owner_team == Team.type.RED:
		print("bah")
		red_score += delta

	elif control_zone.owner_team == Team.type.BLUE:
		blue_score += delta

	if red_score >= winning_amount:
		check_overtime(Team.type.RED)
	if blue_score >= winning_amount:
		check_overtime(Team.type.BLUE)
	
	print("owner: ", control_zone.owner_team)
	print("red score: ", red_score)
	#print("blue score: ", blue_score)


func init(control_zone : ControlZone, view_system : ViewSystem):
	self.control_zone = control_zone
	red_ui = view_system.red_match_ui
	blue_ui = view_system.blue_match_ui

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
