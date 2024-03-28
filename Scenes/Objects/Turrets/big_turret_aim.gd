extends Node2D

var player_nearby: bool = false

@export var rotation_easing: float = 0.1
@export var player_proximity_detector: Area2D
@export var bullet_scene: PackedScene
@export var spread: float = 10
@export var bullet_spawn_point: Node2D
@export var reload_timer: Timer
var has_reloaded = true


func _ready() -> void:
	player_proximity_detector.body_entered.connect(_on_prox_detector_body_entered)
	player_proximity_detector.body_exited.connect(_on_prox_detector_body_exited)


func _physics_process(delta: float) -> void:
	var target_angle = global_position.angle_to_point(GlobalRefs.player_node.global_position)
	if player_nearby:
		target_angle += PI
	global_rotation = lerp_angle(global_rotation,target_angle,rotation_easing)
	
	if Input.is_action_pressed("place_turret") and has_reloaded:
		shoot()
	


func _on_prox_detector_body_entered(body) -> void:
	if body is PlayerController:
		player_nearby = true


func _on_prox_detector_body_exited(body) -> void:
	if body is PlayerController:
		player_nearby = false


func shoot():
	has_reloaded = false
	reload_timer.start()
	var bullet_instance = bullet_scene.instantiate()
	GlobalRefs.bullet_holder.add_child.call_deferred(bullet_instance)
	var target_angle = deg_to_rad(randf_range(-spread,spread)) + bullet_spawn_point.global_rotation
	bullet_instance.global_position = bullet_spawn_point.global_position
	bullet_instance.global_rotation = target_angle
	bullet_instance.initialize_velocity(target_angle,200.0)


func _on_reload_timer_timeout() -> void:
	has_reloaded = true
