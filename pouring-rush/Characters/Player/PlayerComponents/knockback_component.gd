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
	
	var horizontal = Vector2(dir.x, 0)
	var vertical = Vector2(0, -1)
	
	var horizontal_weight = 0.8
	var vertical_weight = 0.4
	# scaling like smash
	var force = hit.base_knockback + percent * hit.knockback_growth
	
	# reduce based on weight
	force *= (1 / weight)
	
	# the direction of the knockback is effected by the shots knockback type
	match hit.knockback_type:
		HitData.KnockbackType.BOOM:
			vertical_weight = 0.6
			horizontal_weight = 0.9
			
		HitData.KnockbackType.LAUNCHER:
			vertical_weight = 0.4
			horizontal_weight = 0.9
			
		HitData.KnockbackType.SPIKE:
			vertical_weight = -0.6
			horizontal_weight = 1.0
	
	var final_dir = (horizontal * horizontal_weight + vertical * vertical_weight).normalized()
	
	# checks if enough force to send in to tumble state
	if tumble_state != null:
		if force > tumble_threshold:
			player.state_machine.on_state_interupt_state(tumble_state)
	
	# sets the final force vector2 for use in moving the player
	var final_force = final_dir * force

	# moves the player with the calculated knockback force times direction
	player.velocity += final_force
	
	# make the ko component check if player is on wall/Ceiling
	player.KO_component.check_immedate_impact()
