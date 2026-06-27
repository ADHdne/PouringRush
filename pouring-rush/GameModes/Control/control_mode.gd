extends GameMode
class_name ControlMode


@onready var control_timer: Timer = $ControlTimer


var control_zone : ControlZone

var taking_control : Team.type

var control_time : float = 5


var red_score : int
var blue_score : int

var winning_amount : int = 100

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if control_zone.owner_team == Team.type.RED:
		red_score += delta

	elif control_zone.owner_team == Team.type.BLUE:
		blue_score += delta

	if red_score >= winning_amount:
		check_overtime(Team.type.RED)
	if blue_score >= winning_amount:
		check_overtime(Team.type.BLUE)


func init(control_zone : ControlZone):
	self.control_zone = control_zone

func check_overtime(team : Team.type):
	match team:
		Team.type.RED:
			if control_zone.blue_count <= 0:
				end_match("Red Team Won!")
				match_manager.end_match()
		Team.type.BLUE:
			if control_zone.red_count <= 0:
				end_match("Blue Team Won!")
				match_manager.end_match()
