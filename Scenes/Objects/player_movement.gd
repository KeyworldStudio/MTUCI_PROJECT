extends CharacterBody2D
class_name PlayerController

@export var speed = 600.0

func _physics_process(delta):
	var direction:Vector2 =Vector2( Input.get_axis("move_left", "move_right"), Input.get_axis("move_up","move_down"))
	direction = direction.normalized()
	velocity = direction * speed * delta
	move_and_slide()
	look_at(get_global_mouse_position())

func _on_area_2d_body_entered(body):
	if(body is BasicTurret):
		body.activated = true

func _on_area_2d_body_exited(body):
	if(body is BasicTurret):
		body.activated = false

