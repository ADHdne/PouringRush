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
	
	match hit.knockback_type:
		HitData.KnockbackType.POKE:
			vertical_weight = 0.5
			horizontal_weight = 0.9
		HitData.KnockbackType.LAUNCHER:
			vertical_weight = 0.4
			horizontal_weight = 0.9
		HitData.KnockbackType.SPIKE:
			vertical_weight = -0.6
			horizontal_weight = 1.0
	
	var final_dir = (horizontal * horizontal_weight + vertical * vertical_weight).normalized()
	
	body.velocity += final_dir * force
