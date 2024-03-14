class_name HealthComponent
extends Node

signal health_zero
signal healed(new_health)
signal damaged

@export var max_health:= 10.0
var health: float = max_health


func _ready():
	health = max_health


# нанесение урона
func damage(attack: Attack, resists: Resists):       
	#print_debug(str(self) + "'s Health: " + str(health))
	health -= max(attack.attack_damage - resists.armor, 0)
	damaged.emit(health)
	if health <= 0:
		health_zero.emit()        


# лечение
func healing(recovery):            
	health += recovery
	healed.emit()


# максимальное восстановление
func healing_to_max():             
	health = max_health


# обнуление здоровья
func zeroing_out_health():         
	health = 0
	health_zero.emit() 
