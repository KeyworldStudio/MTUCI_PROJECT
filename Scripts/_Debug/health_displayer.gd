extends Label

@onready var health: float
@onready var scrap: int

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	update_label()

func _on_health_component_damaged(new_value):
	health = new_value
	update_label()


func _on_resource_component_scrap_changed(new_value):
	scrap = new_value
	update_label()

func update_label():
	text = "H:" + str(health) +  "\nM:" + str(scrap)
