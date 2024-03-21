class_name HealthComponent
extends Node

signal health_zero
signal healed(new_value)
signal damaged(new_value)
signal health_changed(new_value)

@export var max_health:= 10.0
var health: float = max_health:
	set(new_value):
		health = clampf(new_value,0,max_health)
		health_changed.emit(health)


func _ready():
	health = max_health


# нанесение урона
func damage(attack: Attack, resists: Resists): 
	if health<=0:
		return  
	health -= max(attack.attack_damage - resists.armor, 0)
	damaged.emit(health)
	if health <= 0:
		health_zero.emit()        


# лечение
func heal(recovery):    
	health = minf(health + recovery, max_health)
	healed.emit()


# максимальное восстановление
func healing_to_max():             
	health = max_health


# обнуление здоровья
func zeroing_out_health():         
	health = 0
	health_zero.emit() 
