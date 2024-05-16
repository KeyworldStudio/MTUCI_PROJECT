extends RayCast2D

@export var sprite: Sprite2D
@export var hurtbox: Node2D

func _ready():
	pass

func _on_timer_timeout():
	enabled = true

func _on_timer_2_timeout():
	enabled = false
