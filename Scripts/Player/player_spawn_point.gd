class_name PlayerSpawnPoint
extends Marker2D

@export var force_scrap_amount: bool
@export var scrap_amount: int 

func _ready():
	GlobalRefs.player_node.global_position = global_position 
	if force_scrap_amount:
		GlobalRefs.player_node.resource_component.collected_scrap = scrap_amount
