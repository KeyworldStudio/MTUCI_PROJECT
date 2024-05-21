class_name RayCastHurtBox
extends RayCast2D

signal hit_is_applied

@export var attack: Attack
@export var knockback_origin: Node2D
@export var active: bool = true
@export var single_use: bool = false
var collided_area: Node2D

func _ready() -> void:
	hit_from_inside = true
	collide_with_areas = true

func _physics_process(delta: float) -> void:
	if active and is_colliding():
		collided_area = get_collider()
		if collided_area is HitBox:
			process_hit()
		if single_use:
			queue_free.call_deferred()

func process_hit():
	if knockback_origin:
		attack.attack_position = knockback_origin.global_position 
	else:
		attack.attack_position = global_position
	collided_area.damage(attack)
	hit_is_applied.emit()
