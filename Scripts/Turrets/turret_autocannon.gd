extends CharacterBody2D

@export var cannon_shots: int = 2
@export var reload_time: float = 2.0
@export var reload_variance: float = 0.5
@export var bullet_scene: PackedScene
@export var spread = 0.0

var l_shots: int = 0
var r_shots: int = 0
@export var l_bullet_place: Node2D
@export var r_bullet_place: Node2D

@export var l_charge_indicator: Bone2D
@export var l_charge_min: Node2D
@export var l_charge_max: Node2D

@export var r_charge_indicator: Bone2D
@export var r_charge_min: Node2D
@export var r_charge_max: Node2D


@onready var l_reload_timer:= Timer.new()
@onready var r_reload_timer:= Timer.new()
@onready var anim_tree:= $VISUAL/AnimationTree


func _ready() -> void:
	_prep_timer(l_reload_timer, _on_reload_l_timeout)
	_prep_timer(r_reload_timer, _on_reload_r_timeout)


func _physics_process(delta: float) -> void:
	if !l_reload_timer.is_stopped(): 
		move_charge_indicator(l_charge_indicator, l_charge_min, l_charge_max, 1.0 - l_reload_timer.time_left/l_reload_timer.wait_time)
	if !r_reload_timer.is_stopped(): 
		move_charge_indicator(r_charge_indicator, r_charge_min, r_charge_max, 1.0 - r_reload_timer.time_left/r_reload_timer.wait_time)

func move_charge_indicator(indicator_node: Bone2D, min_node: Node2D, max_node: Node2D, ratio: float):
	indicator_node.global_position = min_node.global_position.lerp(max_node.global_position, ratio)

func finish_setup() -> void: 
	anim_tree.set("parameters/Transition/transition_request", "Shoot")
	shoot_l()
	shoot_r()


func start_reload_timer(timer: Timer) -> void:
	timer.start(reload_time + randf_range(-reload_variance, reload_variance))


func shoot_l() -> void:
	if l_shots < cannon_shots:
		anim_tree.set("parameters/ShootLeftOS/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		l_shots += 1 
		spawn_bullet(l_bullet_place)
		move_charge_indicator(l_charge_indicator, l_charge_min, l_charge_max, 1.0 - float(l_shots)/cannon_shots)
	else:
		l_shots = 0
		start_reload_timer(l_reload_timer)


func shoot_r() -> void:
	if r_shots < cannon_shots:
		anim_tree.set("parameters/ShootRightOS/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		r_shots += 1 
		spawn_bullet(r_bullet_place)
		move_charge_indicator(r_charge_indicator, r_charge_min, r_charge_max, 1.0 - float(r_shots)/cannon_shots)
	else:
		r_shots = 0
		start_reload_timer(r_reload_timer)


func spawn_bullet(spawn_point: Node2D) -> void: 
	var instance = bullet_scene.instantiate()
	GlobalRefs.bullet_holder.add_child.call_deferred(instance)
	if spawn_point:
		var spread_rad = deg_to_rad(spread)
		var intended_angle:float = spawn_point.global_rotation + randf_range(-spread_rad, spread_rad) 
		instance.global_position = spawn_point.global_position
		instance.global_rotation = intended_angle
		instance.initialize_velocity(intended_angle)


func _prep_timer(timer: Timer, timeout_function: Callable) -> void:
	if !timer.timeout.is_connected(timeout_function):
		timer.timeout.connect(timeout_function)
	add_child(timer)
	timer.one_shot = true


func _on_reload_l_timeout() -> void:
	shoot_l()


func _on_reload_r_timeout() -> void:
	shoot_r()

