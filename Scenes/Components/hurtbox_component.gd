class_name HurtBox
extends Area2D


@export var attack: Attack


func _ready():
	area_entered.connect(_on_area_entered)
	

func _on_area_entered(area):
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
	
		hitbox.damage(attack)
	
	
