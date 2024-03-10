class_name TurretCreator
extends Area2D

@export var turret: PackedScene

var objects_in_scope: int = 0

func _ready():
	body_entered.connect(_on_area_2d_body_entered)
	body_exited.connect(_on_area_2d_body_exited)

func _on_area_2d_body_entered(body):
	objects_in_scope += 1

func _on_area_2d_body_exited(body):
	objects_in_scope -= 1

func turret_creation():
	if Input.is_action_pressed(("place_turret")) and objects_in_scope == 0:
		var instance = turret.instantiate()
		GlobalRefs.turret_holder.add_child(instance)
		instance.global_position = global_position
		instance.global_rotation = global_rotation
func _physics_process(delta):
	turret_creation()
