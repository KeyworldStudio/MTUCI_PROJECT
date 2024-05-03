class_name DeathComponent
extends Node

signal died

@export var health_component: HealthComponent: 
	set(new_value):
		health_component = new_value
		if health_component is HealthComponent:
			health_component.health_zero.connect(death)

@export var target: Node

# функция смерти
func death():
	if target == GlobalRefs.player_node:
		get_tree().reload_current_scene.call_deferred()
	else:
		target.queue_free()
	died.emit()
