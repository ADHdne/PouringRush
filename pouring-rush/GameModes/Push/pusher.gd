extends PushObject
class_name Pusher




@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var capture_area: Area2D = $CaptureArea
@export var sound_effects : Node
@export var footstep_timer : Timer
@export var push_sound_timer : Timer



@export var return_speed : float = 100
@export var push_speed : float = 50

var lane : PushLane

var red_barrier : PushBarrier
var blue_barrier : PushBarrier

var red_count  : int = 0
var blue_count : int = 0

var state : PusherStates.State = PusherStates.State.IDLE

func _physics_process(delta: float) -> void:
	match state:
		
		PusherStates.State.IDLE:
			pass
		
		PusherStates.State.TO_RED:
			move_to_red(return_speed, delta)
		
		PusherStates.State.TO_BLUE:
			move_to_blue(return_speed, delta)
		
		PusherStates.State.PUSH_RED:
			push_red(delta)
		
		PusherStates.State.PUSH_BLUE:
			push_blue(delta)
	
	# playing movement sounds
	if state != PusherStates.State.IDLE:
		if footstep_timer.time_left <= 0:
			walking_sound()
	if state == PusherStates.State.PUSH_RED or state == PusherStates.State.PUSH_BLUE:
		if push_sound_timer.time_left <= 0:
			pushing_sound()

# gets called from 
func set_up(lane : PushLane, red_barrier : PushBarrier, blue_barrier : PushBarrier):
	self.red_barrier = red_barrier
	self.blue_barrier = blue_barrier
	self.lane = lane


# Durring match

func set_state(new_state : PusherStates.State):
	state = new_state


func move_to_red(speed : float, delta : float):
	progress += speed * delta
	sprite.flip_h = false

func move_to_blue(speed : float, delta : float):
	progress -= speed * delta
	sprite.flip_h = true

func push_red(delta : float):
	
	if red_barrier == null:
		return
	
	var move_amount = push_speed * delta
	progress += move_amount
	red_barrier.progress += move_amount

func push_blue(delta : float):
	
	if blue_barrier == null:
		return
	
	var move_amount = push_speed * delta
	progress -= move_amount
	blue_barrier.progress -= move_amount

func pushing_sound():
	sound_effects.push()
	push_sound_timer.start(0.8)

func walking_sound():
	sound_effects.walk()
	footstep_timer.start(0.7)


func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if area.owner is PushBarrier:

		var barrier : PushBarrier = area.owner

		match barrier.team:

			Team.type.RED:
				SignalBus.pushing_barrier.emit(Team.type.RED)

			Team.type.BLUE:
				SignalBus.pushing_barrier.emit(Team.type.BLUE)



func _on_area_2d_area_exited(area: Area2D) -> void:
	
	if area.owner is PushBarrier:

		var barrier : PushBarrier = area.owner

		match barrier.team:

			Team.type.RED:
				SignalBus.stopped_pushing_barrier.emit()

			Team.type.BLUE:
				SignalBus.stopped_pushing_barrier.emit()


func _on_capture_area_area_entered(area: Area2D) -> void:
	
	if area is HurtboxComponent:
		
		if area._owner.team == Team.type.RED:
			red_count += 1

		if area._owner.team == Team.type.BLUE:
			blue_count += 1
	
		SignalBus.evaluate_control.emit()




func _on_capture_area_area_exited(area: Area2D) -> void:
	if area is HurtboxComponent:
		if area._owner.team == Team.type.RED:
			red_count -= 1
		if area._owner.team == Team.type.BLUE:
			blue_count -= 1

		SignalBus.evaluate_control.emit()
