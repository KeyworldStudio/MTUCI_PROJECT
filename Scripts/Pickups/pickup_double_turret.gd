extends Area2D
class_name TurretPickup
signal picked_up
@export var turret_scene: TurretPlacementData

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is PlayerController:
		body.get_node("TurretCreator").turrets.append(turret_scene)
		picked_up.emit()
		queue_free()
