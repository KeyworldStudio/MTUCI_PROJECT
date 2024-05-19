extends Node2D

@export var mana: int = 100
@export var enemy_data: Array[EnemyPlacementData]
@export var enemy_cap: float = 30
@export var wave_max_number: int = 8
@export var wave_time: int = 5
@export var prize_scene: PackedScene


var wave_timeout: bool = false
var wave_number: int = 0
var spawn_points: Array[Node2D]
var chosen_spawn_points: Array[Node2D]
var enemy_count: int = 0
var enemy_spawn_queue: Array[EnemyPlacementData]

@onready var wave_timer:= Timer.new()



func sort_price(a, b) -> bool:
	if a.price < b.price:
		return true
	return false

func _ready() -> void:
	print_debug(enemy_data.size())
	print_debug(enemy_data)
	print_debug(enemy_cap)
	for i in get_children():
		spawn_points.append(i)
	add_child(wave_timer)
	wave_timer.timeout.connect(_on_wave_cooldown_timeout)
	wave_timer.start(wave_time)
	if not EnemyDeathSignalBus.enemy_died.is_connected(_on_enemy_death):
		EnemyDeathSignalBus.enemy_died.connect(_on_enemy_death)
	enemy_data.sort_custom(sort_price)
	start_new_wave()

func _physics_process(_delta) -> void:
	# Will change this to use the death signal
	if (enemy_count == 0) or wave_timeout:
		wave_timeout = false
		end_of_wave()

func start_new_wave() -> void:
	choose_spawn_points()
	wave_timer.start(wave_time)
	for i in enemy_cap * 3:
		var picked_idx: int = randi_range(0,len(enemy_data)-1)
		for j in range(picked_idx, -1, -1):
			if enemy_data[j].price <= mana:
				if enemy_count < enemy_cap:
					spawn_an_enemy(enemy_data[j])
				else:
					enemy_spawn_queue.push_back(enemy_data[j])
				break



func spawn_an_enemy(chosen_enemy: EnemyPlacementData) -> void:
	var instance = chosen_enemy.scene.instantiate()
	GlobalRefs.enemy_holder.add_child.call_deferred(instance)
	instance.global_position = \
			chosen_spawn_points[\
				randi_range(0, len(chosen_spawn_points) - 1)\
			].global_position
	mana -= chosen_enemy.price
	enemy_count += 1



func end_of_wave() -> void:
	if wave_number < wave_max_number:
		wave_number += 1
		mana = wave_number * 100
		start_new_wave()
	elif wave_number == wave_max_number and GlobalRefs.enemy_holder.get_child_count() == 0:
		return
		prize_scene.instantiate()

func _on_wave_cooldown_timeout() -> void:
	wave_timeout = true

func _on_enemy_death(manager_linked) -> void:
	if manager_linked:
		enemy_count -= 1
		var queued_enemy = enemy_spawn_queue.pop_front()
		if queued_enemy:
			spawn_an_enemy(queued_enemy)

func choose_spawn_points() -> void:
	chosen_spawn_points = []
	for i in maxi(
			randi_range(1, len(spawn_points)),
			randi_range(1, len(spawn_points))
			):
		chosen_spawn_points.append(spawn_points[randi_range(0, len(spawn_points) - 1)])
