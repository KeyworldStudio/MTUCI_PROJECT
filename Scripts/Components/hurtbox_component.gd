class_name HurtBox
extends Area2D

signal hit_is_applied

@export var attack: Attack
@export var knockback_origin: Node2D
@export var active: bool = true
@export var single_use: bool = false

func _ready():
	area_entered.connect(_on_area_entered)


func _on_area_entered(area):
	if !(area is HitBox):
		return

	if !(active):
		return

	var hitbox : HitBox = area              

	# определение координат атаки
	if knockback_origin:
		attack.attack_position = knockback_origin.global_position 
	else:
		attack.attack_position = global_position

	hitbox.damage(attack)
	hit_is_applied.emit()
	if single_use:
		queue_free.call_deferred()
