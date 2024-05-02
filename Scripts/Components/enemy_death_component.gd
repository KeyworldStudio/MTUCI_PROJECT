class_name EnemyDeathComponent
extends Node



@export var health_component: HealthComponent: 
	set(new_value):
		health_component = new_value
		if health_component is HealthComponent:
			health_component.health_zero.connect(death)

@export var target: Node


@export var drop_spawner: DropSpawner

# функция смерти
func death():
	if drop_spawner:
		drop_spawner.spawn_drops()                                  
	target.queue_free()
	EnemyDeathSignalBus.enemy_died.emit()
