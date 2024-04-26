class_name StepTarget
extends Node2D

@export var target: Node2D
@export var trigger_distance: float = 25
@export var rest_distance: float = 2
@export var linear_speed: float = 200
@export var proportional_speed: float = 0.2
@export var required_points: Array[StepTarget] 

var is_following: bool = false

@onready var prev_position: Vector2 = target.global_position


	
func check_dist(rest_position: Vector2):
	var supported = true
	for i in required_points:
		if i.is_following:
			supported = false
	if supported and global_position.distance_squared_to(target.global_position) > trigger_distance*trigger_distance:
		is_following = true
	elif  global_position.distance_squared_to(rest_position) < rest_distance * rest_distance:
		is_following = false

func _physics_process(delta):
	var rest_position = target.global_position + prev_position.direction_to(target.global_position) * trigger_distance
	check_dist(rest_position)
	if is_following:
		set_global_position(
				global_position.lerp(rest_position, proportional_speed)\
				.move_toward(rest_position, linear_speed * delta )
			)
			
	
	
	prev_position = target.global_position
	
