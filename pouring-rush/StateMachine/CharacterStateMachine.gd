extends Node
class_name CharacterStateMachine

# different references
@export var player : Player
#@export var hurtbox : PlayerHurtbox
@export var animation_tree : AnimationTree
# reference states
@export var current_state : State
@export var hit_state : State
@export var dead_state : State
@export var block_state : State
@export var shieldbroken_state : State

var states : Array[State]
var player_dead : bool = false

func _ready():
	for child in get_children():
		if child is State:
			states.append(child)
			
			# set the states up with what they need to function
			child.player = player
			#child.playback = animation_tree["parameters/playback"]
			
			# connect to interupt signal
			child.connect("interupt_state", on_state_interupt_state)
		else:
			push_warning("Child " + child.name + " is not a State for CharacterStateMachine")


func _physics_process(delta):
	if current_state.next_state != null:
		switch_states(current_state.next_state)
	
	current_state.state_process(delta)

func check_if_can_move():
	return current_state.can_move

func switch_states(new_state : State):
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
		
	current_state = new_state
	
	current_state.on_enter()

func _input(event : InputEvent):
	current_state.state_input(event)

func on_state_interupt_state(new_state : State):
	switch_states(new_state)
	
func _is_hit():
	if current_state != block_state and current_state != dead_state and not player_dead:
		on_state_interupt_state(hit_state)

func _on_health_depleted():
	on_state_interupt_state(dead_state)
	player_dead = true

func _on_shield_depleted():
	on_state_interupt_state(shieldbroken_state)
