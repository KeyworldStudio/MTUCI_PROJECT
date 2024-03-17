class_name DeathComponent
extends Node

signal died

@export var health_component: HealthComponent: 
	set(new_value):
		health_component = new_value
		if health_component is HealthComponent:
			health_component.health_zero.connect(death)


# функция смерти
func death():
	if health_component.get_parent() == GlobalRefs.player_node:
		get_tree().reload_current_scene()
	else:
		health_component.get_parent().queue_free()
		died.emit()
