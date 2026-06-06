extends Node
class_name DamageComponent



@export var damage_profle : DamageProfile

@export var procentage : float = 0.0


func apply_damage(amount : float):
	procentage += amount
	return


func apply_heal(amount : float):
	procentage -= amount
	return
