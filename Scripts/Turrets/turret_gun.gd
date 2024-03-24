extends Node2D

@export var timer: Timer 
@export var bullet: PackedScene
@export var bullet_place: Node2D
@export var bullet_speed = 100.0
#@onready var bullet_holder = 

var turret_base: Turret
var activated = false
var on_cooldown = false
var direction_input = 0


func shoot():
	var instance = bullet.instantiate()
	GlobalRefs.bullet_holder.add_child.call_deferred(instance)
	instance.original_turret_base = turret_base
	if bullet_place:
		var intended_angle:float = bullet_place.global_rotation +deg_to_rad(randf_range(-10,10))
		instance.global_position = bullet_place.global_position
		instance.global_rotation = intended_angle
		instance.initialize_velocity(intended_angle,bullet_speed)
		
	
func _on_timer_timeout():
	shoot()
