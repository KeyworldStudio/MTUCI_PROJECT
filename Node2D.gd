extends CharacterBody2D

@export var speed = 100


func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	if velocity.length_squared()>0:
		rotation = velocity.angle()
	move_and_slide()
	
	
