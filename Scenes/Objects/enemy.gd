extends CharacterBody2D

@export var speed: float = 50.0
@export var dash_speed: float = 100.0

@export var player: Node2D
@onready var nav_agent: = $NavigationAgent2D as NavigationAgent2D

func _physics_process(_delta: float) -> void:
	pass

func makepath() -> void:
	nav_agent.target_position = player.global_position

func motion_pursuit() -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()

func motion_attack() -> void:
	velocity = global_position.direction_to(player.global_position) * dash_speed
	move_and_slide()

func _on_timer_timeout() -> void:
	makepath()

func _on_area_2d_body_entered(body) -> void:
	if body is PlayerController:
		$StateChart.send_event("player_close")

func _on_pursuit_state_physics_processing(_delta):
	motion_pursuit()

func _on_attack_state_physics_processing(delta):
	motion_attack()
