extends CharacterBody2D

@export var speed: float = 50.0
@export var dash_speed: float = 25.0
@export var pursuit_acceleration: float = 400.0
@export var dash_acceleration: float = 2000.0
@export var rest_acceleration: float = 500.0
@export var explosion_scene: PackedScene
@export var explosion_place: Node2D

var nav_agent_safe_velocity: Vector2
var desired_velocity: Vector2 
var acceleration: float
var dash_target: Vector2

@onready var player: = GlobalRefs.player_node
@onready var nav_agent: = $MOTION/NavigationAgent2D as NavigationAgent2D
@onready var player_detector: = $MOTION/PlayerDetector as Area2D
@onready var health_component: = $COMBAT/HealthComponent as HealthComponent
@onready var anim_player: = $VISUAL/AnimationPlayer as AnimationPlayer


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
			0.05
		)


func _on_pursuit_state_entered():
	acceleration = pursuit_acceleration
	change_detector_disabled(false)
	

func _on_pursuit_state_exited():
	change_detector_disabled(true)
#endregion


#region Explode state
func motion_attack() -> void:	
	var dir = global_position.direction_to(player.global_position)
	var intended_velocity = dir * dash_speed
	desired_velocity = intended_velocity


func _on_explode_state_physics_processing(delta):
	motion_attack()


func _on_explode_state_entered():
	acceleration = dash_acceleration
	anim_player.play("Explode")

func explode():
	var explosion_instance = explosion_scene.instantiate()
	GlobalRefs.bullet_holder.add_child(explosion_instance)
	if explosion_place:
		explosion_instance.global_position = explosion_place.global_position
	else:
		explosion_instance.global_position = global_position
	health_component.kill()
#endregion


#region Navigation
func makepath() -> void:
	if !player:
		return
	nav_agent.target_position = player.global_position


func _on_timer_timeout():
	makepath()


func _on_player_detector_body_entered(body):
	if body is PlayerController:
		$StateChart.send_event("player_close")


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	nav_agent_safe_velocity = safe_velocity
#endregion



