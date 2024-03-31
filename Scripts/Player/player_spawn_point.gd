class_name PlayerSpawnPoint
extends Marker2D


func _ready():
	GlobalRefs.player_node.global_position = global_position 
	
