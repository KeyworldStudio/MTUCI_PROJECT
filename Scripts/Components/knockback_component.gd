class_name KnockbackComponent
extends Node

signal knockback_applied

@export var target: CharacterBody2D


func apply_knockback(direction: Vector2, knockback_force: float, resists: Resists):
	var kb_coeff: float = resists.coefficient_of_knockback
	var kb_velocity: Vector2 = direction.normalized() * knockback_force 
	
	if kb_coeff<=1:
		target.velocity = target.velocity.lerp(kb_velocity, kb_coeff)
	else: 
		target.velocity = kb_velocity * kb_coeff
	target.move_and_slide()
	knockback_applied.emit()
