extends Node2D

@export var waves: Array[EnemyWave]
var current_enemies: int:
	set = _set_current_enemies
var current_wave: int = 0
@onready var wave_timer: Timer = Timer.new()

func _ready():
	wave_timer.one_shot = true 
	wave_timer.autostart = false
	EnemyDeathSignalBus.enemy_died.connect(_on_enemy_died)
	wave_timer.timeout.connect(_on_wave_timer_timeout)
	
func spawn_wave():
	if current_wave >= waves.size(): 
		return
	var wave_data = waves[current_wave]
	current_enemies = wave_data.enemy_count
	wave_timer.start(wave_data.wave_time)
	var wave_scene = wave_data.wave_scene.instantiate()
	add_child(wave_scene)
	
func _on_enemy_died():
	current_enemies -= 1

func wave_end():
	wave_timer.stop()
	current_wave += 1
	spawn_wave()
	
func _on_wave_timer_timeout():
	wave_end()

func _set_current_enemies(value: int): 
	current_enemies = value
	if current_enemies<=0:
		wave_end()







