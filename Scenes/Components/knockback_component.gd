class_name KnockbackComponent
extends Node

signal knockback_applied

@export var target: CharacterBody2D

func apply_knockback(direction: Vector2, knockback_force: float, resists: Resists):
	target.velocity = direction.normalized() * knockback_force * resists.coefficient_of_knockback
	target.move_and_slide()
	knockback_applied.emit()
