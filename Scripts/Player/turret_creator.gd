class_name TurretCreator
extends Area2D

@export var turrets: Array[TurretPlacementData]
@export var resource_component: ResourceTrackerComponent

var objects_in_scope: int = 0
var current: int = 0

func _ready():
	body_entered.connect(_on_area_2d_body_entered)
	body_exited.connect(_on_area_2d_body_exited)

func _on_area_2d_body_entered(_body):
	objects_in_scope += 1

func _on_area_2d_body_exited(_body):
	objects_in_scope -= 1

func size_change():
	get_child(0).shape.radius = turrets[current].size
	position.x = turrets[current].size + 10

func turret_change():
	if (Input.is_action_just_pressed('turret_change_left') and current > 0):
		current -= 1
	if (Input.is_action_just_pressed('turret_change_right') and current < (len(turrets) -1)):
		current += 1
	size_change()
		
func turret_creation():
	if (
			Input.is_action_just_pressed(("place_turret")) 
			and resource_component.collected_scrap >= turrets[current].price
			and objects_in_scope == 0
		):
		resource_component.collected_scrap -= turrets[current].price
		var instance = turrets[current].scene.instantiate()
		GlobalRefs.turret_holder.add_child.call_deferred(instance)
		instance.set_deferred("global_position", global_position)
		instance.set_deferred("global_rotation", global_rotation)

func _physics_process(_delta):
	turret_creation()
	turret_change()
