extends CharacterBody2D

@export var speed: float = 50.0
@export var pursuit_acceleration: float = 400.0
@export var attack_acceleration: float = 100.0
@export var charge_velocity: float = 300.0
@export var rest_acceleration: float = 500.0

var nav_agent_safe_velocity: Vector2
var desired_velocity: Vector2 
var acceleration: float
var charge_dir: Vector2
var max_charge_speed: float

@onready var player: = GlobalRefs.player_node
@onready var nav_agent: = $MOTION/NavigationAgent2D as NavigationAgent2D
@onready var player_sightline: = $MOTION/SightLine as RayCast2D
@onready var hurtbox_component: = $COMBAT/HurtBox as HurtBox


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
	player_sightline.enabled = true
#endregion


#region Attack state
func motion_attack() -> void:
	desired_velocity = charge_dir * charge_velocity
	max_charge_speed = maxf(velocity.length_squared(), max_charge_speed)
	rotation = lerp_angle(
			rotation,
			charge_dir.angle(),
			0.3
		)
	


func _on_attack_state_physics_processing(delta):
	motion_attack()


func _on_attack_state_entered():
	max_charge_speed = 0
	hurtbox_component.active = true
	player_sightline.enabled = false
	acceleration = attack_acceleration
	charge_dir = global_position.direction_to(player.global_position)
#endregion


#region Rest state
func motion_rest() -> void:
	desired_velocity = Vector2.ZERO


func _on_rest_state_physics_processing(delta):
	motion_rest()


func _on_rest_state_entered():
	acceleration = rest_acceleration
	velocity = Vector2.from_angle(randi()) * sqrt(max_charge_speed)
#endregion


#region Navigation
func makepath() -> void:
	if !player:
		return
	nav_agent.target_position = player.global_position


func _on_timer_timeout():
	makepath()
	player_sightline.global_rotation = 0
	player_sightline.target_position = player.global_position - global_position
	await get_tree().physics_frame
	if not(player_sightline.is_colliding()):
		$StateChart.send_event("see_the_player")


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	nav_agent_safe_velocity = safe_velocity
#endregion


func _on_front_collision_detector_body_entered(body):
	$StateChart.send_event("atk_to_rest")


func _on_hurt_box_hit_is_applied():
	$StateChart.send_event("atk_to_rest")
