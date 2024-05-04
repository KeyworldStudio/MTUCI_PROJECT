extends Node2D

@export var mana: int = 100
@export var enemy_data: Array[EnemyPlacementData]
@export var wave_max_number: int = 8
@export var max_number_of_tries: int = 5
@export var wave_time: int = 5
@export var prize_scene: PackedScene
@export var enemy_cap: int = 20

@onready var wave_timer:= Timer.new()

var wave_timer_run_out: bool = false
var wave_number: int = 0
var number_of_tries: int = 0
var chosen_enemy: EnemyPlacementData
var initial_spawn_points: Array[Node2D]
var actual_spawn_points: Array[Node2D]

func sort_price(a, b):
	if a.price < b.price:
		return true
	return false

func _ready():
	for i in get_children():
		initial_spawn_points.append(i)
	add_child(wave_timer)
	wave_timer.timeout.connect(_on_wave_cooldown_timeout)
	wave_timer.start(wave_time)
	enemy_data.sort_custom(sort_price)
	start_new_wave()

func _physics_process(delta):
	if (GlobalRefs.enemy_holder.get_child_count() == 0) or wave_timer_run_out:
		wave_timer_run_out = false
		end_of_wave()

func start_new_wave():
	choose_spawn_points()
	wave_timer.start(wave_time)
	while mana > 0:
		choose_an_enemy()
		number_of_tries = 0
		while chosen_enemy.price > mana or chosen_enemy.starting_wave > wave_number:
			number_of_tries += 1
			chosen_enemy = enemy_data[len(enemy_data) - number_of_tries]
			if number_of_tries == len(enemy_data) + 1:
				break
		if number_of_tries == len(enemy_data) + 1:
			break
		var instance = chosen_enemy.scene.instantiate()
		GlobalRefs.enemy_holder.add_child.call_deferred(instance)
		instance.global_position = actual_spawn_points[randi() % (len(actual_spawn_points) - 1)].global_position
		mana -= chosen_enemy.price
	return 0

func choose_an_enemy():
	chosen_enemy = enemy_data[randf_range(0, len(enemy_data))]

func end_of_wave():
	if wave_number < wave_max_number:
		wave_number += 1
		mana += wave_number * 100
		start_new_wave()
		return 0
	if wave_number == wave_max_number and GlobalRefs.enemy_holder.get_child_count() == 0:
		prize_scene.instantiate()
		return 0

func _on_wave_cooldown_timeout():
	wave_timer_run_out = true
	
func choose_spawn_points():
	actual_spawn_points = []
	for i in randf_range(0, len(initial_spawn_points) - 1):
		actual_spawn_points.append(initial_spawn_points[randi() % (len(initial_spawn_points) - 1)])
