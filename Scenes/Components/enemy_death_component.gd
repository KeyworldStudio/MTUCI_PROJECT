class_name EnemyDeathComponent
extends Node



@export var health_component: HealthComponent: 
	set(new_value):
		health_component = new_value
		if health_component is HealthComponent:
			health_component.health_zero.connect(death)


# функция смерти
func death():                                             
	health_component.get_parent().queue_free()
	EnemyDeathSignalBus.enemy_died.emit()
