extends Node2D

@export var bullet: PackedScene
@export var bullet_place: Node2D

var activated = false
var direction_input = 0

func _physics_process(delta):
	if activated == true:
		if Input.is_action_just_pressed("ui_accept"):
			shoot()
		direction_input = direction_input + Input.get_axis("ui_left", "ui_right")
		rotation_degrees = direction_input

func shoot():
	var instance = bullet.instantiate()
	add_child(instance)
	if bullet_place:
		instance.global_position = bullet_place.global_position
		instance.initialize_velocity(bullet_place.global_rotation,200)
		instance.global_rotation = bullet_place.global_rotation
