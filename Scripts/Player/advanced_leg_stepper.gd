class_name AdvancedLegStepper
extends Node2D

@export var target: Node2D
@export var required_points: Array[AdvancedLegStepper]
var is_following: bool = false
var is_supported: bool = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position = target.global_position
	global_rotation = target.global_rotation
