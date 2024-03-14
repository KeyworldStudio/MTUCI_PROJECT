extends Node2D

var velocity: Vector2
var original_turret_base: Turret

func _physics_process(delta):
	position += velocity * delta

func initialize_velocity(direction: float, speed: float):
	velocity = Vector2.from_angle(direction) * speed

func _on_area_2d_body_entered(body):
	if !(body == original_turret_base):
		queue_free()


func _on_hurt_box_hit_is_applied():
	queue_free()
