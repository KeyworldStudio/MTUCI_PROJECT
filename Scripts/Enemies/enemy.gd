extends CharacterBody2D

@export var speed: float = 50.0
@export var dash_speed: float = 100.0
@export var pursuit_acceleration: float = 400.0
@export var dash_acceleration: float = 2000.0
@export var rest_acceleration: float = 500.0

var nav_agent_safe_velocity: Vector2
var desired_velocity: Vector2 
var acceleration: float
var dash_target: Vector2

@onready var player: = GlobalRefs.player_node
@onready var nav_agent: = $MOTION/NavigationAgent2D as NavigationAgent2D
@onready var player_detector: = $MOTION/PlayerDetector as Area2D


func _physics_process(delta):
	velocity = velocity.move_toward(desired_velocity,acceleration * delta)
	#velocity = Vector2.RIGHT * 10
	move_and_slide()


func change_detector_disabled(new_value: bool) -> void:
	for i in player_detector.get_children():
		if i is CollisionShape2D or i is CollisionPolygon2D:
			i.set_deferred("disabled", new_value)


#region Pursuit state
func motion_pursuit() -> void:
	var dir = global_position.direction_to(nav_agent.get_next_path_position())
	var intended_velocity = dir * speed
	nav_agent.set_velocity(intended_velocity)
	desired_velocity = nav_agent_safe_velocity


func _on_pursuit_state_physics_processing(_delta):
	motion_pursuit()
	
	rotation = lerp_angle(
			rotation,
			global_position.angle_to_point(
					nav_agent.get_next_path_position()
				),
			0.2
		)


func _on_pursuit_state_entered():
	acceleration = pursuit_acceleration
	change_detector_disabled(false)


func _on_pursuit_state_exited():
	change_detector_disabled(true)
#endregion


#region Attack state
func motion_attack() -> void:
	if !player:
		return
	
	desired_velocity = global_position.direction_to(dash_target) * dash_speed


func _on_attack_state_physics_processing(_delta):
	motion_attack()


func _on_attack_state_entered():
	acceleration = dash_acceleration
	dash_target = player.global_position
	rotation = global_position.angle_to_point(dash_target)
#endregion


#region Rest state
func motion_rest() -> void:
	desired_velocity = Vector2.ZERO


func _on_rest_state_physics_processing(_delta):
	motion_rest()


func _on_rest_state_entered():
	acceleration = rest_acceleration
#endregion


#region Navigation
func makepath() -> void:
	if !player:
		return
	nav_agent.target_position = player.global_position


func _on_timer_timeout() -> void:
	makepath()


func _on_area_2d_body_entered(body) -> void:
	if body is PlayerController:
		$StateChart.send_event("player_close")


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	nav_agent_safe_velocity = safe_velocity
#endregion
