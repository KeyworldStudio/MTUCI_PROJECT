extends StaticBody2D
class_name Turret

@export var guns: Array[Node2D]:
	set(new_value):
		guns = new_value
		for i in guns:
			i.turret_base = self
var activated = false:
	set(new_value):
		activated = new_value
		for i in guns:
			i.activated = activated
