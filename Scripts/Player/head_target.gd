extends Marker2D

@export var ref_frame: Node2D
@export var min_displacement: float = 1
@onready var prev_position: Vector2 = global_position



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	var displacement: Vector2 = global_position - prev_position
	var angle_offset: float = 0
	
	if abs(angle_difference(displacement.angle(), ref_frame.global_rotation)) >= PI/2.0:
		angle_offset = PI
	
	if displacement.length_squared() >= min_displacement * min_displacement: 
		global_rotation = displacement.angle() + angle_offset
	else:
		global_rotation = ref_frame.global_rotation
	
	
	prev_position = global_position
