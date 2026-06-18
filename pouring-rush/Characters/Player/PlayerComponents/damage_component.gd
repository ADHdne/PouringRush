extends Node
class_name DamageComponent

## a component controlling the health/percentage of a character (or object?)

@export var percentage : float = 0.0
@export var player : Player


# get the data from hurtbox

func apply_damage(hit : HitData, attacker : Player):
	if attacker.team == player.team:
		percentage += (hit.damage / 2)
	else:
		percentage += hit.damage
	return


func apply_heal(hit : HitData, attacker : Player):
	if attacker.team == player.team:
		percentage -= hit.healing
		if percentage < 0:
			percentage = 0
	return
