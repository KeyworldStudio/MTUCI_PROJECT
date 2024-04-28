class_name PlayerController
extends CharacterBody2D

@export var acceleration = 1800.0
@export var max_speed = 100.0
@export var friction = 100.0
@export var dash_speed: float = 500.0
@export var hitbox: HitboxComponent
@export var dash_cooldown: float = 3
@export var dash_invuln: float = 0.3

var can_dash: bool = true

@onready var dash_cooldown_timer: Timer = Timer.new()
@onready var dash_invuln_timer: Timer = Timer.new()


func _ready():
	add_child(dash_cooldown_timer)
	dash_cooldown_timer.one_shot = true
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timeout)
	add_child(dash_invuln_timer)
	dash_invuln_timer.one_shot = true
	dash_invuln_timer.timeout.connect(_on_dash_invuln_timeout)

func _physics_process(delta):
	var direction: Vector2 = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up","move_down"))
	direction = direction.normalized()
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	if Input.is_action_just_pressed("dash") and can_dash:
		velocity = direction * dash_speed
		can_dash = false
		dash_cooldown_timer.start(dash_cooldown)
		hitbox.active = false
		dash_invuln_timer.start(dash_invuln)
	move_and_slide()
	look_at(get_global_mouse_position())


func _on_dash_cooldown_timeout():
	can_dash = true

func _on_dash_invuln_timeout():
	hitbox.active = true
