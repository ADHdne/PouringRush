extends Node
class_name KnockbackComponent


@export var body : CharacterBody2D
@export var damage_component : DamageComponent

func apply_knockback(hit : HitData):
	var precent = damage_component.percentage
	var weight = body.stats.weight
	
	# scaling like smash
	var force = hit.base_knockback + (precent * hit.knockback_growth)
	
	# reduce based on weight
	force *= (1 / weight)
	
	var dir = hit.direction.normalized()
	
	body.velocity += dir * force
	print("direction: ", dir, " force: ", force)
