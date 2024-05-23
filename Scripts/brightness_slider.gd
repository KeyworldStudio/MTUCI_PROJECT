extends HSlider

@export var base_glow_intensity: float = 0.8
@export var base_brightness: float = 1.0
@export var world_env: WorldEnvironment


func _ready():
	if !value_changed.is_connected(_on_value_changed):
		value_changed.connect(_on_value_changed)
	_on_value_changed(value)


func _on_value_changed(value):
	world_env.environment.adjustment_brightness = base_brightness * value
	world_env.environment.glow_intensity = base_glow_intensity / value
	
