extends Marker2D

@export var distance_ratio: float = 0.2
@export var stick_offset_length: float = 54
var using_mouse: bool = true

func _physics_process(delta):
	var desired_position: = GlobalRefs.player_node.get_global_position()
	var aim_direction:= \
			Vector2(
				Input.get_axis("aim_left","aim_right"),
				Input.get_axis("aim_up","aim_down")
				)
	if aim_direction.length_squared() > 0.0:
		using_mouse = false
		
	
	if Input.get_last_mouse_velocity().length_squared() > 0.0:
		using_mouse = true
	
	if using_mouse:
		desired_position *=( 1 - distance_ratio) 
		desired_position += distance_ratio*get_global_mouse_position()
	else:
		desired_position += aim_direction * stick_offset_length
	
	global_position = desired_position
