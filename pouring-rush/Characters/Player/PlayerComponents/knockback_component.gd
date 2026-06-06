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
	
	
	var horizontal_weight = 0.8
	var vertical_weight = 0.4

	var dir = hit.direction.normalized()

	var horiz = Vector2(dir.x, 0)
	var vert = Vector2(0, -1)
	
	var final_dir = (horiz * horizontal_weight + vert * vertical_weight).normalized()
	
	body.velocity += final_dir * force
	print("direction: ", dir, " force: ", force)
