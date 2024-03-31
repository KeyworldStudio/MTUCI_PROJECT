class_name LevelTransition

extends Area2D
@export var level_scene: PackedScene

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body == GlobalRefs.player_node:
		GlobalRefs.game_world_node.change_level(level_scene)
		
	



