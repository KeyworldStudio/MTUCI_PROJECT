class_name HealthComponent
extends Node


@export var max_health:= 10.0
var health : float


func _ready():
	health = max_health
	
func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		get_parent().queue_free()
		
