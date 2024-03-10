extends Node2D

@export var timer: Timer 
@export var bullet: PackedScene
@export var bullet_place: Node2D
@export var bullet_speed = 200.0
@onready var bullet_holder = GlobalRefs.bullet_holder

var activated = false
var on_cooldown = false
var direction_input = 0

func _physics_process(delta):
	if activated and not on_cooldown:
		shoot()

func shoot():
	timer.start()
	on_cooldown = true
	var instance = bullet.instantiate()
	bullet_holder.add_child(instance)
	if bullet_place:
		instance.global_position = bullet_place.global_position
		instance.initialize_velocity(bullet_place.global_rotation,bullet_speed)
		instance.global_rotation = bullet_place.global_rotation

func _on_timer_timeout():
	on_cooldown = false
