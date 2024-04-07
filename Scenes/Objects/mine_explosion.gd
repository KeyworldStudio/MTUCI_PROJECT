extends Node2D

var activated = false

func _physics_process(delta):
	explode()

func explode():
	if activated == true:
		for i in get_children():
			if i is CollisionShape2D or i is CollisionPolygon2D:
				i.set_deferred("disabled", 0)

