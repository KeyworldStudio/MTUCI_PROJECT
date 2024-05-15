extends Node2D

@export var small_bullets: PackedScene

var velocity: Vector2
var original_turret_base: Turret

func _physics_process(delta):
	position += velocity * delta

func initialize_velocity(direction: float, speed: float):
	velocity = Vector2.from_angle(direction) * speed

func _on_area_2d_body_entered(body):
	if !(body == original_turret_base):
		spawn_fragments()
		queue_free()

func _on_hurt_box_hit_is_applied():
	spawn_fragments()
	queue_free()

func spawn_fragments():
	for i in randf_range(2, 8):
		var instance = small_bullets.instantiate()
		var intended_angle = randf_range(0, 360)
		instance.global_position = global_position
		instance.global_rotation = intended_angle
		instance.initialize_velocity(intended_angle, 100)
		GlobalRefs.bullet_holder.add_child.call_deferred(instance)
	
