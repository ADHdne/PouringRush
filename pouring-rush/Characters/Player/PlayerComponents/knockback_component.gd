extends Node
class_name KnockbackComponent


@export var player : Player
@export var damage_component : DamageComponent

@export var tumble_state : State

@export var tumble_threshold : float = 5

# getting hit_data from hurtbox

func apply_knockback(hit : HitData):
	var percent = damage_component.percentage
	var weight = player.character_data.weight
	var dir = hit.direction.normalized()
	
	var vertical_bias : float = -0.2
	
	if dir.y >= -0.2:
		dir.y = vertical_bias
	
	var horizontal_weight = 0.8
	var vertical_weight = 0.4
	# scaling like smash
	var force = hit.base_knockback + percent * hit.knockback_growth
	print("force: ", force)
	# reduce based on weight
	force *= (1 / weight)
	
	# the direction of the knockback is effected by the shots knockback type
	match hit.knockback_type:
		HitData.KnockbackType.BOOM:
			weight = Vector2(0.9,0.6)
			
		HitData.KnockbackType.LAUNCHER:
			weight = Vector2(0.9,0.4)
			
		HitData.KnockbackType.SPIKE:
			weight = Vector2(1,-0.6)
	
	var final_dir = dir.normalized()
	
	# checks if enough force to send in to tumble state
	if tumble_state != null:
		if force > tumble_threshold:
			player.state_machine.on_state_interupt_state(tumble_state)
	
	# sets the final force vector2 for use in moving the player
	var final_force = final_dir * force

	# moves the player with the calculated knockback force times direction
	player.velocity += final_force
