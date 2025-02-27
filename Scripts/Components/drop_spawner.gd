class_name DropSpawner
extends Node2D

@export var min_drops: int = 1:
	set(new_value):
		min_drops = maxi(0,mini(new_value,max_drops))
@export var max_drops: int = 3:
	set(new_value):
		max_drops = maxi(new_value,min_drops)
@export var drop_velocity: int = 128:
	set(new_value):
		drop_velocity = maxi(0, new_value)


@onready var drop_scene: PackedScene = preload("res://Scenes/Objects/scrap_collectible.tscn")


func spawn_drops():
	var i = randi_range(min_drops,max_drops)
	for j in i:
		var angle = randf_range(0,2*PI)
		var distance = randf_range(0,drop_velocity)
		var drop_instance = drop_scene.instantiate()
		var intended_velocity = Vector2.from_angle(angle) * distance
		
		GlobalRefs.drop_holder.add_child.call_deferred(drop_instance)
		drop_instance.set_deferred("global_position", global_position)
		drop_instance.set_deferred("linear_velocity", intended_velocity)
		drop_instance.set_deferred("global_rotation", randf_range(0,2*PI))
