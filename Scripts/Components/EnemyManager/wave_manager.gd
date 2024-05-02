class_name WaveManager
extends Node2D

@export var waves: Array[EnemyWave]
@export var loop_count: int = 0

var current_enemies: int:
	set = _set_current_enemies
var current_wave: int = 0

@onready var wave_timer: Timer = Timer.new()

func _ready():
	add_child(wave_timer)
	wave_timer.one_shot = true
	EnemyDeathSignalBus.enemy_died.connect(_on_enemy_died)
	wave_timer.timeout.connect(_on_wave_timer_timeout)
	spawn_wave()

func spawn_wave():
	if current_wave >= waves.size(): 
		if loop_count <= 0:
			return
		loop_count-=1
		current_wave = 0
	var wave_data = waves[current_wave]
	current_enemies += wave_data.enemy_count
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
	current_enemies = maxi(value,0)
	if current_enemies==0:
		wave_end()
