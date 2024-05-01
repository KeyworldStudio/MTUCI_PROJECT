extends CharacterBody2D

@export var speed: float = 50.0
@export var pursuit_acceleration: float = 400.0
@export var attack_acceleration: float = 500.0
@export var bullet: PackedScene
@export var bullet_place: Node2D
@export var bullet_speed: float = 500.0

var nav_agent_safe_velocity: Vector2
var desired_velocity: Vector2 
var acceleration: float
var shoot_target: Vector2

@onready var player: = GlobalRefs.player_node
@onready var nav_agent: = $NAVIGATION/NavigationAgent2D as NavigationAgent2D
@onready var player_sightline: = $NAVIGATION/SightLine as RayCast2D


func _physics_process(delta):
	velocity = velocity.move_toward(desired_velocity,acceleration * delta)
	#velocity = Vector2.RIGHT * 10
	move_and_slide()


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
	#player_sightline.enabled = true
#endregion


#region Attack state
func motion_attack() -> void:
	desired_velocity = Vector2.ZERO


func shoot():
	var instance = bullet.instantiate()
	GlobalRefs.bullet_holder.add_child(instance)
	if bullet_place:
		var intended_angle:float = bullet_place.global_rotation 
		instance.global_position = bullet_place.global_position
		instance.global_rotation = intended_angle
		instance.initialize_velocity(intended_angle,bullet_speed)


func _on_attack_state_physics_processing(_delta):
	motion_attack()


func _on_attack_state_entered():
	#player_sightline.enabled = false
	acceleration = attack_acceleration
	rotation = global_position.angle_to_point(player.global_position)
	shoot()
#endregion


#region Navigation
func makepath() -> void:
	if !player:
		return
	nav_agent.target_position = player.global_position
	player_sightline.target_position = player.global_position - global_position
	player_sightline.global_rotation = 0
	if not(player_sightline.is_colliding()):
		$StateChart.send_event("see_the_player")



func _on_timer_timeout() -> void:
	makepath()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	nav_agent_safe_velocity = safe_velocity
#endregion
