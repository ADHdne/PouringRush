extends Area2D
class_name HurtboxComponent

@export var damage_component : DamageComponent
@export var knockback_component : KnockbackComponent

@export var _owner : Player


func recieve_hit(hit_data : HitData, player : Player):

	if knockback_component != null:
		knockback_component.apply_knockback(hit_data)
	if damage_component != null:
		damage_component.apply_damage(hit_data, player)
		damage_component.apply_heal(hit_data, player)
