extends Label

@onready var health: float
@onready var scrap: int = 10

func _on_health_component_damaged(new_value):
	health = new_value
	text = "H:" + str(health) +  "\nM:" + str(scrap)


func _on_resource_component_scrap_changed(new_value):
	await get_tree().process_frame
	scrap = new_value
	text = "H:" + str(health) + "\nM:" + str(scrap)

