class_name HealthComponent
extends Node

signal health_zero
signal healed
signal damaged

@export var max_health:= 10.0
@export var health: float


func _ready():
	health = max_health


#нанесение урона
func damage(attack: Attack):       
	health -= attack.attack_damage
	damaged.emit()
	if health <= 0:
		health_zero.emit()        


#лечение
func healing(recovery):            
	health += recovery
	healed.emit()


#максимальное восстановление
func healing_to_max():             
	health = max_health


#обнуление здоровья
func zeroing_out_health():        
	health = 0
	health_zero.emit() 
