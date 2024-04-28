extends Node2D

var velocity: Vector2


func _physics_process(delta):
	position += velocity * delta


func initialize_velocity(direction: float, speed: float):
	velocity = Vector2.from_angle(direction) * speed


func _on_area_2d_body_entered(body):
	queue_free()


func _on_hurt_box_hit_is_applied():
	queue_free()
