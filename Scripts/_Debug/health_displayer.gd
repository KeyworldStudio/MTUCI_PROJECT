extends Label

func _on_health_component_damaged(new_value):
	text = str(new_value)
