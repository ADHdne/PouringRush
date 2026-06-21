extends Control
class_name PlayerIcon


var player: Player
var combat_component : CombatComponent


@export var portrait : TextureRect
@onready var percent: Label = $Percent

# the shots cooldowns
@export var basic_shot : TextureRect
@export var magazine : Label

@export var special_1 : TextureRect
@export var special_1_bar : ProgressBar



@export var special_2 : TextureRect
@export var special_2_bar : ProgressBar

@export var utility : TextureRect
@export var utility_bar : ProgressBar

func _process(delta):
	if player == null:
		return

	# updating the different labels taxt
	percent.text = str(player.damage_component.percentage) + "%"
	magazine.text = str(combat_component.basic_shot_data.current_ammo)
	
	# updating progress bars
	special_1_bar.value = combat_component.special_shot_data.cooldown_remaining
	special_2_bar.value = combat_component.special_2_data.cooldown_remaining
	utility_bar.value = combat_component.utility_data.cooldown_remaining
	
	# updating sprite if alive
	check_player_alive(delta)


func setup(p: Player):
	player = p
	combat_component = player.combat_component
	
	
	portrait.texture = player.character_data.portrait
	set_up_abilities(combat_component)

func set_up_abilities(component : CombatComponent):
	# setting up all abilities textures
	basic_shot.texture = component.basic_shot_data.ability_data.projectile_data.texture
	special_1.texture = component.special_shot_data.ability_data.projectile_data.texture
	special_2.texture = component.special_2_data.ability_data.projectile_data.texture
	utility.texture = component.utility_data.ability_data.projectile_data.texture
	
	# setting progressbars max_value
	special_1_bar.max_value = component.special_shot_data.ability_data.ability_cooldown
	special_2_bar.max_value = component.special_2_data.ability_data.ability_cooldown
	utility_bar.max_value = component.utility_data.ability_data.ability_cooldown
	
func check_player_alive(delta):
	if player.alive:
		portrait.modulate = Color(1.0, 1.0, 1.0)
	else:
		portrait.modulate = Color(0.478, 0.478, 0.478, 0.651)
