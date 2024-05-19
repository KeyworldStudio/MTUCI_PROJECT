extends GridContainer

@export var turrets: Array[TurretPlacementData]

signal pressed(turret_id)
signal turret_selected(turret_id)

func _ready():
	for turret in turrets:
		var button = Button.new()
		button.name = turret.turret_id
		button.icon = turret.icon
		var turret_id = int(String(button.name))
		add_child(button)
		button.connect("pressed", Callable(self, "_on_pressed"), turret_id)
		

func _on_pressed(turrert_id):
	emit_signal("turret_selected")
	print_debug("Кнопка нажата!")
