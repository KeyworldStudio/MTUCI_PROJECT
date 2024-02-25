
extends CharacterBody2D
<<<<<<< HEAD:Scenes/Objects/player_movement.gd
@export var speed = 300.0


func _physics_process(delta):
=======
@export var speed: float = 100.0
func _physics_process(_delta):
>>>>>>> f69de13 (velocity tweaks):player_movement.gd
	var direction:Vector2 =Vector2( Input.get_axis("move_left", "move_right"), Input.get_axis("move_up","move_down"))
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
