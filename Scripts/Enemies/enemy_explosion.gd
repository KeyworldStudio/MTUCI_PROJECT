extends Area2D

@onready var part_sys:= $ExplosionParticles

@export var attack_data: Attack
@export var radius: float = 96

func _ready() -> void:
	part_sys.emitting = true
	part_sys.finished.connect(_on_fx_expired)
	area_entered.connect(_on_area_entered)


func _on_fx_expired():
	queue_free()

func _on_area_entered(area):
	var raycast_target: Vector2 = global_position.direction_to(area.global_position) * radius
	var raycast_instance = RayCastHurtBox.new()
	raycast_instance.global_rotation = 0.0
	raycast_instance.target_position = raycast_target
	raycast_instance.attack = attack_data
	raycast_instance.single_use = true
	raycast_instance.set_collision_mask_value(1, true)
	raycast_instance.set_collision_mask_value(3, true)
	raycast_instance.set_collision_mask_value(5, true)
	add_child(raycast_instance)


func _on_timer_timeout() -> void:
	monitoring = false
