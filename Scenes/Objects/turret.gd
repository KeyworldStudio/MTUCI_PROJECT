extends StaticBody2D
class_name BasicTurret

@export var guns: Array[Node2D]
var activated = false
func _physics_process(delta):
	for i in guns:
		i.activated = activated
