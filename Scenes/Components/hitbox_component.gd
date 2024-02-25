class_name HitboxComponent
extends Area2D


signal hit_received
signal beginning_of_invulnerability
signal end_of_invulnerability

@export var health_component: HealthComponent
@export var knockback_component: KnockbackComponent
@export var active: bool = true:
	set(new_value):
		active = new_value
		for i in get_children():
			if i is CollisionShape2D or i is CollisionPolygon2D:
				i.set_deferred("disabled", invulnerability or !active)
				
@export var resists: Resists
@export var knockback_target: Node2D

var invulnerability: bool = false:
	set(new_value):
		invulnerability = new_value
		for i in get_children():
			if i is CollisionShape2D or i is CollisionPolygon2D:
				i.set_deferred("disabled", invulnerability or !active)
				
@export var timer: Timer:
	set(new_value):
		timer = new_value
		if timer is Timer:
			timer.timeout.connect(disable_invulnerability)


func disable_invulnerability():         #функция отключения неуязвимости
	invulnerability = false
	end_of_invulnerability.emit()
	

func damage(attack: Attack):            #функция получения удара и начала неуязвимости 
	
	if !(active):
		return
	
	if invulnerability:
		return
	
	if health_component: 
		health_component.damage(attack)
	
	if knockback_component:
		var knockback_vector: Vector2
		if knockback_target:
			knockback_vector = knockback_target.global_position - attack.attack_position
		else:
			knockback_vector = global_position - attack.attack_position
		knockback_component.apply_knockback(knockback_vector,attack.knockback_force)
	
	if timer:
		timer.start()
		invulnerability = true
		beginning_of_invulnerability.emit()
	
	hit_received.emit()
	
	
	
	
	
