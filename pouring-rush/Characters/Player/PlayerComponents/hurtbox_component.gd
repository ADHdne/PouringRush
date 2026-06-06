extends Area2D
class_name HurtboxComponent

@export var damage_component : DamageComponent
@export var knockback_component : KnockbackComponent

@export var _owner : Player


func recieve_hit(damage : float, knockback : Vector2):
	if damage_component != null:
		damage_component.apply_damage(damage)
	if knockback_component != null:
		knockback_component.apply_knockback(knockback)
