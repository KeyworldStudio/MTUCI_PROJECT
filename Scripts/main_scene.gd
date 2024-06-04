extends Node

var is_paused: bool = false

func _ready():
	GlobalRefs.main_scene_node = $"."
	GlobalRefs.player_node = $GameWorld/Player/PlayerController as PlayerController
	GlobalRefs.game_world_node = $GameWorld as Node2D
	GlobalRefs.bullet_holder = $GameWorld/Bullets  as Node2D
	GlobalRefs.turret_holder = $GameWorld/Turrets  as Node2D
	GlobalRefs.enemy_holder = $GameWorld/Enemies  as Node2D
	GlobalRefs.drop_holder = $GameWorld/Drops as Node2D
	GlobalRefs.gui_holder = $MainGUI as Control
	GlobalRefs.player_camera_controller = $GameWorld/Player/PlayerCameraController as PhantomCamera2D
	GlobalRefs.world_environment = $GameWorld/WorldEnvironment
	GlobalRefs.pause_menu = $MainGUI/PauseMenu


func _process(delta: float) -> void: 
	pass

func toggle_pause():
	if is_paused:
		GlobalRefs.pause_menu.hide()
		get_tree().paused = false
	else:
		GlobalRefs.pause_menu.show()
		get_tree().paused = true
	is_paused = !is_paused

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if !is_paused:
			toggle_pause()
