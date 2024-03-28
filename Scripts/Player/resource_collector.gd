extends Area2D

@export var resource_component: ResourceTrackerComponent

func _ready():
	self.area_entered.connect(_on_area_entered)
	#print_debug(self.body_entered.is_connected(_on_body_entered))


func _on_area_entered(area):
	resource_component.collected_scrap += area.nominal
	area.queue_free()
