extends Area2D

@export var resource_component: ResourceTrackerComponent

func _ready():
	self.body_entered.connect(_on_body_entered)
