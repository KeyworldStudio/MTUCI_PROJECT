extends CharacterBody2D

@export var bullet_scene: PackedScene
@export var bullet_place: Node2D
@export var spread = 0.0

@onready var anim_player: = $VISUALS/AnimationPlayer
@onready var reload_timer: = $ReloadTimer

func _ready() -> void:
	reload_timer.timeout.connect(_on_reload_timer_timeout)

func shoot() -> void:
	anim_player.play("Shoot")

func spawn_bullet() -> void:
	var instance = bullet_scene.instantiate()
	GlobalRefs.bullet_holder.add_child.call_deferred(instance)
	if bullet_place:
		var spread_rad = deg_to_rad(spread)
		var intended_angle:float = bullet_place.global_rotation + randf_range(-spread_rad, spread_rad) 
		instance.global_position = bullet_place.global_position
		instance.global_rotation = intended_angle
		instance.initialize_velocity(intended_angle)

func start_reload_timer() -> void:
	reload_timer.start()

func _on_reload_timer_timeout() -> void:
	shoot()
