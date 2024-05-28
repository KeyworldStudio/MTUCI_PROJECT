class_name StepTarget
extends Node2D

signal step_landed

@export var target: RayCast2D
@export var foot_size: float = 3
@export var trigger_distance: float = 25
@export var hard_limit: float = 40
@export var rest_trigger_distance: float = 3
@export var rest_distance: float = 2
@export var linear_speed: float = 100
@export var proportional_speed: float = 0.2
@export var required_points: Array[StepTarget] 

var target_position: Vector2 = Vector2.ZERO
var is_following: bool = false
var supported: bool = true
var target_pos_velocity_dir: Vector2 = Vector2.ZERO
var prev_position: Vector2

func _ready():
	target_position = update_target_position()
	global_position = target_position
	prev_position = target_position

func _physics_process(delta):
	target_position = update_target_position()
	var rest_position = target_position + prev_position.direction_to(target_position) * trigger_distance
	
	#check_dist(rest_position, trigger_distance)
	if is_following:
		approach_pos(
				rest_position, 
				linear_speed, 
				proportional_speed,
				delta
			)
	check_dist(rest_position, trigger_distance)

	if global_position.distance_squared_to(target_position) > hard_limit * hard_limit:
		global_position = target_position - \
		Vector2.from_angle(
				global_position.\
				angle_to_point(target_position)
			) * hard_limit
		for i in required_points:
			is_following = true
	prev_position = target_position

func check_dist(rest_position: Vector2, trigger_distance: float): 
	supported = true
	for i in required_points:
		if i.is_following:
			supported = false
	if supported and global_position.distance_squared_to(target_position) > trigger_distance*trigger_distance:
		is_following = true
	elif global_position.distance_squared_to(rest_position) <= rest_distance * rest_distance and is_following:
		is_following = false
		step_landed.emit()

func approach_pos(rest_position: Vector2, linear_speed: float, proportional_speed: float, delta: float) -> void:
	global_position = global_position\
			.move_toward(rest_position,linear_speed * delta)\
			.lerp(rest_position,proportional_speed)

func update_target_position() -> Vector2:
	if !target.is_colliding():
		return target.global_position \
				+ target.target_position.rotated(target.global_rotation)
	
	return target.get_collision_point() \
			+ target.get_collision_normal() \
			* foot_size
