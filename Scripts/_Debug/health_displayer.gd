extends Label

var health: float
var scrap: int

func _on_health_component_damaged(new_value):
	health = new_value
	text = "H:" + str(health) + " | S:" + str (scrap)


func _on_resource_component_scrap_changed(new_value):
	scrap = new_value
	text = "H:" + str(health) + " | S:" + str (scrap)
