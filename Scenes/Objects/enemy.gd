extends CharacterBody2D

@export var speed: float = 50.0
@export var dash_speed: float = 100.0


var nav_agent_safe_velocity: Vector2 = Vector2.ZERO

@onready var player: = GlobalRefs.player_node
@onready var nav_agent: = $NavigationAgent2D as NavigationAgent2D
@onready var player_detector: = $PlayerDetector as Area2D


func change_detector_disabled(new_value: bool) -> void:
	for i in player_detector.get_children():
		if i is CollisionShape2D or i is CollisionPolygon2D:
			i.set_deferred("disabled", new_value)


func makepath() -> void:
	if !player:
		return
	nav_agent.target_position = player.global_position


#region Pursuit state
func motion_pursuit() -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	var intended_velocity = dir * speed
	nav_agent.set_velocity(intended_velocity)
	velocity = nav_agent_safe_velocity
	move_and_slide()


func _on_pursuit_state_physics_processing(_delta):
	motion_pursuit()


func _on_pursuit_state_entered():
	change_detector_disabled(false)


func _on_pursuit_state_exited():
	change_detector_disabled(true)
#endregion


#region Attack state
func motion_attack() -> void:
	if !player:
		return
	
	velocity = global_position.direction_to(player.global_position) * dash_speed
	move_and_slide()


func _on_attack_state_physics_processing(_delta):
	motion_attack()
#endregion


#region Rest state
func motion_rest() -> void:
	velocity = Vector2.ZERO


func _on_rest_state_physics_processing(_delta):
	motion_rest()
#endregion


func _on_timer_timeout() -> void:
	makepath()


func _on_area_2d_body_entered(body) -> void:
	if body is PlayerController:
		$StateChart.send_event("player_close")


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	nav_agent_safe_velocity = safe_velocity
