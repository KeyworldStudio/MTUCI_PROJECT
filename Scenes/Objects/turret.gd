extends StaticBody2D
class_name Turret

@export var guns: Array[Node2D]
var activated = false:
	set(newvalue):
		activated = newvalue
		for i in guns:
			i.activated = activated
