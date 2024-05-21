class_name ShapeCastHurtBox
extends ShapeCast2D

signal hit_is_applied

@export var attack: Attack
@export var active: bool = true
@export var knockback_origin: Node2D
var collided_area: Node2D

func _physics_process(delta: float) -> void:
	if active and is_colliding():
		
		for attempted_idx: int in get_collision_count():
			collided_area = get_collider(attempted_idx)
			if collided_area is HitBox:
				process_hit()

func process_hit():
	if knockback_origin:
		attack.attack_position = knockback_origin.global_position 
	else:
		attack.attack_position = global_position
	collided_area.damage(attack)
	hit_is_applied.emit()
