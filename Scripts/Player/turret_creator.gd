class_name TurretCreator
extends Area2D

@export var turrets: Array[TurretPlacementData]
@export var resource_component: ResourceTrackerComponent
@export var placement_collider: CollisionShape2D
@export var placement_indicator: Sprite2D:
	set(value):
		placement_indicator = value
		indicator_tex_size = placement_indicator.texture.get_size()
		placement_indicator.modulate = indicator_disabled_color
@export var aim_indicator: Node2D
@export var indicator_disabled_color: Color = Color.TRANSPARENT
@export var indicator_allowed_color: Color = Color.GREEN
@export var indicator_blocked_color: Color = Color.RED


var indicator_tex_size: Vector2 = Vector2(64, 64)
var objects_in_scope: int = 0
var current: int = 0

func _ready():
	body_entered.connect(_on_area_2d_body_entered)
	body_exited.connect(_on_area_2d_body_exited)

func _on_area_2d_body_entered(_body):
	objects_in_scope += 1

func _on_area_2d_body_exited(_body):
	objects_in_scope -= 1

func size_change():
	position.x = turrets[current].size + 10
	aim_indicator.position.x = turrets[current].size
	placement_collider.shape.radius = turrets[current].size
	placement_indicator.scale.x = 2 * turrets[current].size / indicator_tex_size.x
	placement_indicator.scale.y = 2 * turrets[current].size / indicator_tex_size.y

func turret_change():
	if (Input.is_action_just_pressed('turret_change_left') and current > 0):
		current -= 1
	if (Input.is_action_just_pressed('turret_change_right') and current < (len(turrets) -1)):
		current += 1
	size_change()
		
func turret_creation():
	if (
			Input.is_action_just_released(("place_turret")) 
			and resource_component.collected_scrap >= turrets[current].price
			and objects_in_scope == 0
		):
		resource_component.collected_scrap -= turrets[current].price
		if !turrets[current].scene:
			return
		var instance = turrets[current].scene.instantiate()
		GlobalRefs.turret_holder.add_child.call_deferred(instance)
		instance.set_deferred("global_position", global_position)
		instance.set_deferred("global_rotation", global_rotation)

func indicator_color_set()->void:
	if !Input.is_action_pressed('place_turret'):
		aim_indicator.hide()
		placement_indicator.modulate = indicator_disabled_color
		return
	aim_indicator.show()
	if objects_in_scope <= 0:
		aim_indicator.modulate = indicator_allowed_color
		placement_indicator.modulate = indicator_allowed_color
		return
	aim_indicator.modulate = indicator_blocked_color
	placement_indicator.modulate = indicator_blocked_color
	

func _physics_process(_delta):
	if len(turrets)>0:
		turret_creation()
		turret_change()
		indicator_color_set()
