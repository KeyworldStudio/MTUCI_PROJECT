class_name Resists
extends Resource

var damage_multiplier: float = 1
@export var armor: float = 0:
	set(value):
		armor = value
		damage_multiplier = armor_damage_reduction(armor)
@export var coefficient_of_knockback: float = 1.0

func armor_damage_reduction(armor: float) -> float:
	return (1 - 2*atan(armor/2)/PI)
