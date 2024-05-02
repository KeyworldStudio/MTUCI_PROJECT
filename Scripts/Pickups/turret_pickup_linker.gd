extends Node2D
class_name PickupLinker

func _ready():
	for i in get_children():
		if i is TurretPickup:
			if !i.picked_up.is_connected(end_of_choice):
				i.picked_up.connect(end_of_choice)
func end_of_choice():
	for i in get_children():
		i.queue_free()
