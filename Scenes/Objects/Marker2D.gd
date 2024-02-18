extends Marker2D

var direction_input = 0

func _process(delta):
	direction_input = direction_input + Input.get_axis("ui_left", "ui_right")
	rotation_degrees = direction_input
