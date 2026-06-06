extends Node
class_name KnockbackComponent


@export var body : CharacterBody2D
@export var damage_component : DamageComponent

func apply_knockback(hit : HitData):
	var percent = damage_component.percentage
	var weight = body.stats.weight
	var dir = hit.direction.normalized()
	
	var horizontal = Vector2(dir.x, 0)
	var vertical = Vector2(0, -1)
	
	var horizontal_weight = 0.8
	var vertical_weight = 0.4
	# scaling like smash
	var force = hit.base_knockback + percent * hit.knockback_growth
	
	# reduce based on weight
	force *= (1 / weight)
	
	

	
	var final_dir = (horizontal * 0.8 + vertical * vertical_weight).normalized()
	
	body.velocity += final_dir * force
