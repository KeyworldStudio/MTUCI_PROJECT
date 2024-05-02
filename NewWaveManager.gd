extends Node2D

@export var mana: int = 100
@export var enemy_data: Array[EnemyPlacementData]
@export var wave_max_number: int = 8
@export var max_number_of_tries: int = 5

var wave_number: int = 0
var number_of_tries: int = 0
var chosen_enemy: EnemyPlacementData

func sort_price(a, b):
	if a.price < b.price:
		return true
	return false

func _ready():
	enemy_data.sort_custom(sort_price)
	start_new_wave()

func start_new_wave():
	while mana > 0:
		choose_an_enemy()
		number_of_tries = 0
		while chosen_enemy.price > mana or chosen_enemy.starting_wave > wave_number:
			number_of_tries += 1
			chosen_enemy = enemy_data[len(enemy_data) - number_of_tries]
			if number_of_tries == len(enemy_data) + 1:
				break
		if number_of_tries == len(enemy_data) + 1:
			end_of_wave()
			break
		var instance = chosen_enemy.scene.instantiate()
		GlobalRefs.enemy_holder.add_child.call_deferred(instance)
		instance.global_position = get_child(randi() % get_child_count()).global_position
		mana -= chosen_enemy.price
	end_of_wave()

func choose_an_enemy():
	chosen_enemy = enemy_data[randf_range(0, len(enemy_data))]

func end_of_wave():
	wave_number += 1
	mana += wave_number * 100
	if wave_number < wave_max_number and GlobalRefs.enemy_holder.get_child_count() == 0:
		start_new_wave()
