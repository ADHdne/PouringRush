extends Node
class_name KnockbackComponent


@export var body : CharacterBody2D
@export var damage_component : DamageComponent

func apply_knockback(hit : HitData):
	var precent = damage_component.percentage
	
	# scaling like smash
	var force = hit.base_knockback + (precent * hit.knockback_growth)
	
	var dir = hit.direction.normalized()
	
	body.velocity += dir * force
	print("direction: ", dir, " force: ", force)
