extends Node
class_name DamageComponent


@export var percentage : float = 0.0


func apply_damage(hit : HitData):
	percentage += hit.damage
	return


func apply_heal(hit : HitData):
	percentage -= hit.healing
	return
