class_name TurretCreator
extends Area2D

@export var turret: Array[PackedScene]

var objects_in_scope: int = 0
var chosen_turret: int = 0

func _ready():
	body_entered.connect(_on_area_2d_body_entered)
	body_exited.connect(_on_area_2d_body_exited)

func _on_area_2d_body_entered(body):
	objects_in_scope += 1

func _on_area_2d_body_exited(body):
	objects_in_scope -= 1

func turret_creation():
	if Input.is_action_pressed(("place_turret")) and objects_in_scope == 0:
		var instance = turret[chosen_turret].instantiate()
		GlobalRefs.turret_holder.add_child(instance)
		instance.global_position = global_position
		instance.global_rotation = global_rotation

func turret_change():
	if Input.is_action_pressed("switch_turret_left") and (chosen_turret > 0):
		chosen_turret -= 1
	if Input.is_action_just_pressed("switch_turret_right") and (chosen_turret < (len(turret) - 1)) :
		chosen_turret += 1

func _physics_process(delta):
	turret_creation()
	turret_change()
	

