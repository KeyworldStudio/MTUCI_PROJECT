extends Node2D

@export var starting_scene: PackedScene


func _ready():
	await get_tree().create_timer(0.1).timeout
	var instanced_scene = starting_scene.instantiate()
	add_child(instanced_scene)
	move_child(instanced_scene,0)
	
func change_level(level_scene: PackedScene):
	if get_child(0) != GlobalRefs.drop_holder:
		get_child(0).queue_free()
	for i in GlobalRefs.drop_holder.get_children():
		i.queue_free()
	for i in GlobalRefs.turret_holder.get_children():
		i.queue_free()
	for i in GlobalRefs.enemy_holder.get_children():
		i.queue_free()
	for i in GlobalRefs.bullet_holder.get_children():
		i.queue_free()
	var instanced_scene = level_scene.instantiate()
	add_child(instanced_scene)
	move_child(instanced_scene,0)


