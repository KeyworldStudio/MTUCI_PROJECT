class_name EnemySpawnpoint
extends Sprite2D

@export var enemy_scene: PackedScene
@export var spawn_delay: float = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(spawn_delay).timeout
	var instanced_scene = enemy_scene.instantiate()
	GlobalRefs.enemy_holder.add_child.call_deferred(instanced_scene)
	instanced_scene.set_deferred("global_position", global_position)
	queue_free()
