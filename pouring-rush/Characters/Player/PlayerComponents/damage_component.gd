extends Node
class_name DamageComponent



@export var damage_profle : DamageProfile

@export var percentage : float = 0.0


func apply_damage(amount : float):
	percentage += amount
	return


func apply_heal(amount : float):
	percentage -= amount
	return
