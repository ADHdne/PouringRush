extends Area2D
class_name ControlZone




@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var area_visual: ColorRect = $CollisionShape2D/ColorRect

var owner_team : Team.type = Team.type.GREY

var capture_team : Team.type

var capture_progress : float

var red_count : int
var blue_count : int

var capture_time : float = 5


func _ready() -> void:
	setup_size()


func setup_size():
	
	area_visual.size = collision_shape.shape.get_rect().size
	area_visual.position = -collision_shape.shape.size / 2.0


func _physics_process(delta: float) -> void:
	
	
	# set capture color
	if owner_team == Team.type.RED:
		area_visual.color = Color(0.7, 0.3, 0.3, 0.2)
	elif owner_team == Team.type.BLUE:
		area_visual.color = Color(0.3, 0.3, 0.7, 0.2)
	else:
		area_visual.color = Color(0.4, 0.4, 0.4, 0.2)
	
	# Nobody on point
	if red_count == 0 and blue_count == 0:
		return

	# Contested
	if red_count > 0 and blue_count > 0:
		SignalBus.contested.emit()
		return
	
	var team : Team.type

	if red_count > 0:
		team = Team.type.RED
	else:
		team = Team.type.BLUE

	# Already owned
	if owner_team == team:
		return

	# New team begins capturing
	if capture_team != team:
		capture_team = team
		capture_progress = 0.0

	capture_progress += delta / capture_time

	SignalBus.progress_changed.emit(capture_team, capture_progress)

	if capture_progress >= 1.0:
		owner_team = capture_team
		capture_progress = 0.0

		SignalBus.owner_changed.emit(owner)
	

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		
		if area._owner.team == Team.type.RED:
			red_count += 1

		if area._owner.team == Team.type.BLUE:
			blue_count += 1
	
		SignalBus.evaluate_control.emit()


func _on_area_exited(area: Area2D) -> void:
	if area is HurtboxComponent:
		if area._owner.team == Team.type.RED:
			red_count -= 1
		if area._owner.team == Team.type.BLUE:
			blue_count -= 1

		SignalBus.evaluate_control.emit()


func deactivate():
	visible = false
