extends Node
class_name DamageComponent

## a component controlling the health/percentage of a character (or object?)

@export var percentage : float = 0.0


# get the data from hurtbox

func apply_damage(hit : HitData):
	percentage += hit.damage
	return


func apply_heal(hit : HitData):
	percentage -= hit.healing
	return
