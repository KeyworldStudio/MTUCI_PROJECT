extends Node2D

signal impact_hit

@export var speed: float = 200
@export var impact_particles: SelfCleanupParticles
@export var on_impact_payload: PackedScene
@export var on_miss_payload: PackedScene
@export var on_hit_payload: PackedScene
@export var payload_spawn_point: RayCast2D
var velocity: Vector2


func _physics_process(delta) -> void:
	position += velocity * delta

func initialize_velocity(direction: float) -> void:
	velocity = Vector2.from_angle(direction) * speed

func impact() -> void:
	impact_hit.emit()
	instantiate_scene(on_impact_payload)
	queue_free()
	if !impact_particles:
		return
	impact_particles.emitting = true
	impact_particles.reparent(GlobalRefs.bullet_holder, true)

func _on_area_2d_body_entered(body) -> void:
	instantiate_scene(on_miss_payload)
	impact()


func _on_hurt_box_hit_is_applied() -> void:
	instantiate_scene(on_hit_payload)
	impact()

func instantiate_scene(scene: PackedScene) -> void:
	if !scene: 
		return
	
	var instance = scene.instantiate()
	GlobalRefs.bullet_holder.add_child.call_deferred(instance)
	
	if payload_spawn_point:
		instance.global_position = get_payload_spawn_point()
		instance.global_rotation = payload_spawn_point.global_rotation
		return
	instance.global_position = global_position
	instance.global_rotation = global_rotation

func get_payload_spawn_point() -> Vector2:
	if payload_spawn_point.is_colliding():
		return payload_spawn_point.get_collision_point() + \
				payload_spawn_point.get_collision_normal()
		
	return payload_spawn_point.global_position + \
			payload_spawn_point.target_position.rotated(payload_spawn_point.global_rotation)
	
