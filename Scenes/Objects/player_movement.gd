extends CharacterBody2D
class_name PlayerController

@export var acceleration = 1800.0
@export var max_speed = 400.0
@export var friction = 100.0

func _physics_process(delta):
	var direction:Vector2 =Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up","move_down"))
	direction = direction.normalized()
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()
	look_at(get_global_mouse_position())