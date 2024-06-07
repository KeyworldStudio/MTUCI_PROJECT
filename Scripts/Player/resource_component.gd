class_name ResourceTrackerComponent
extends Node

signal scrap_changed(new_value)


@export var starting_scrap: int = 10
@export var health_component: HealthComponent
@export var heal_cost: int = 10

@onready var collected_scrap: int = starting_scrap:
	set(new_value):
		collected_scrap = maxi(0,new_value)
		scrap_changed.emit(collected_scrap)

func _ready() -> void:
	await get_tree().process_frame
	scrap_changed.emit(collected_scrap)


func _physics_process(_delta):
	if (Input.is_action_just_pressed("heal")
			and collected_scrap>=heal_cost
			and health_component.health<health_component.max_health):
		collected_scrap -= heal_cost
		health_component.heal(1)

