extends CharacterBody2D

@export var speed = 100
@export var acceleration = 100

func _physics_process(delta):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(input_direction * speed, acceleration * delta)

	if velocity.length_squared()>0:
		rotation = velocity.angle()
	move_and_slide()
	
	
