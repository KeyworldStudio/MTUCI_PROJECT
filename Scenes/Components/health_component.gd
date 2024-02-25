class_name HealthComponent
extends Node

signal health_zero
signal healed
signal damaged

@export var max_health:= 10.0
@export var health: float


func _ready():
	health = max_health
	
	
func damage(attack: Attack, resists: Resists):       #нанесения урона
	health -= (attack.attack_damage - resists.armor)
	damaged.emit()
	if health <= 0:
		health_zero.emit()        
	
	
func healing(recovery):            #лечение
	health += recovery
	healed.emit()
	

func healing_to_max():             #максимальное восстановление
	health = max_health


func zeroing_out_health():         #обнуление здоровья
	health = 0
	health_zero.emit() 


