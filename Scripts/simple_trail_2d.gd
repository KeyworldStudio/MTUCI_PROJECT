extends Line2D
class_name SimpleTrail2D

signal fully_stopped

@export var length:int = 50
var stopped: bool = false




func _process(_delta):
	global_position = Vector2.ZERO
	global_rotation = 0
	var originPoint = get_parent().global_position
	
	if stopped:
		remove_point(0)
	else:
		add_point(originPoint)
	
	while get_point_count()>length:
		remove_point(0)
	
	if (get_point_count() == 0) and stopped:
		emit_signal("fully_stopped")
	

