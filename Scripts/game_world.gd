extends Node2D

@export var starting_scene: PackedScene


func _ready():
	await get_tree().create_timer(0.1).timeout
	var instanced_scene = starting_scene.instantiate()
	add_child(instanced_scene)
	move_child(instanced_scene,0)

