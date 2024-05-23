class_name TopDownLegStepper
extends Node2D

@export var target: Node2D
@export var required_points: Array[TopDownLegStepper]
@export var angle_threshold: float = 40
@export var distance_threshold: float = 6
@export var overshoot_distance: float = 4
@export var rest_threshold: float = 1
@export var rest_angle_threshold: float = 5
var is_following: bool = false
var is_supported: bool = true

@onready var prev_pos: Vector2 = global_position
@onready var prev_rotation: float = global_rotation


func _ready() -> void:
	global_position = target.global_position

func _physics_process(delta) -> void:
	var target_position: Vector2 = target.global_position + prev_pos.direction_to(target.global_position) * overshoot_distance
	if is_following:
		follow(
				target_position, 
				target.global_rotation,
				delta
			)
	check_thresholds(target_position, target.global_rotation)
	print((target_position).distance_to(target.global_position))
	prev_pos = target_position
	prev_rotation = global_rotation

func check_thresholds(target_position: Vector2, target_angle: float) -> void:
	check_support()
	if (global_position.distance_squared_to(target_position)\
			 >= distance_threshold * distance_threshold) or \
			(abs(angle_difference(global_rotation,target_angle)) >= deg_to_rad(angle_threshold)):
		if is_supported:
			is_following = true
	if (global_position.distance_squared_to(target_position)\
			 <= rest_threshold * rest_threshold) and \
			(abs(angle_difference(global_rotation,target_angle)) <= deg_to_rad(rest_angle_threshold)):
		is_following = false

func check_support() -> void:
	is_supported = true
	for i in required_points:
		is_supported = is_supported and !i.is_following

func follow(target_position: Vector2, target_rotation: float, delta) -> void:
	global_position = lerp(global_position, target_position, 0.5).move_toward(target_position,100 * delta)
	global_rotation = lerp_angle(global_rotation, target_rotation, 0.2)

 
