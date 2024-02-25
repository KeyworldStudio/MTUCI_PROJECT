extends Node2D

@export var waves: Array[EnemyWave]
@export var wave_timer: EnemyWave
@export var alive_enemies: int = 0 

var current_wave_index: int = 0
var current_wave: EnemyWave = null
var wave_timer_remaining: float = 0.0

func _on_enemy_death():
	alive_enemies -= 1
	if alive_enemies == 0:
		wave_timer_remaining = 0.0

func _process(delta):
	if current_wave == null:
		if current_wave_index <= waves.size():
			current_wave = waves[current_wave_index]
			spawn_wave(current_wave)
			wave_timer_remaining = wave_timer.wave_timer
			current_wave_index += 1 
			
	if wave_timer_remaining > 0.0:
		wave_timer_remaining -= delta
		if wave_timer_remaining <= 0.0 or alive_enemies == 0:
			current_wave = null
			
func spawn_wave(wave: EnemyWave):
	alive_enemies = wave.enemy_count
	for enemy_data in waves:
		var enemy_instance = enemy_data.enemy_scene.instantiate()
		add_child(enemy_instance)





