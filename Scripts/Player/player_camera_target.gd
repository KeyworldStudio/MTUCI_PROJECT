extends Marker2D

@export var distance_ratio: float = 0.2

func _physics_process(delta):
	global_position = distance_ratio*get_global_mouse_position() + GlobalRefs.player_node.get_global_position()*( 1 - distance_ratio) 
