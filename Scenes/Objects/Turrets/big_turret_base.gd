extends CharacterBody2D

var player_nearby: bool = false

@export var player_proximity_detector: Area2D

func _ready() -> void:
	player_proximity_detector.body_entered.connect(_on_prox_detector_body_entered)
	player_proximity_detector.body_exited.connect(_on_prox_detector_body_exited)


func _physics_process(delta: float) -> void:
	if !player_nearby and Input.is_action_pressed("pull_turret"):
		velocity = global_position.direction_to(GlobalRefs.player_node.global_position) * 100
		move_and_slide()


func _on_prox_detector_body_entered(body) -> void:
	if body is PlayerController:
		player_nearby = true


func _on_prox_detector_body_exited(body) -> void:
	if body is PlayerController:
		player_nearby = false
