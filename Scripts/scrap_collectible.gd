extends CharacterBody2D

@export var nominal: float = 1

func _physics_process(delta):
	move_and_slide()
	velocity = velocity.move_toward(Vector2.ZERO, 10*velocity.length()*delta)
