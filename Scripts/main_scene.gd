extends Node



func _ready():
	GlobalRefs.player_node = $GameWorld/Player/PlayerController as PlayerController
	GlobalRefs.game_world_node = $GameWorld as Node2D
	GlobalRefs.bullet_holder = $GameWorld/Bullets  as Node2D
	GlobalRefs.turret_holder = $GameWorld/Turrets  as Node2D
	GlobalRefs.enemy_holder = $GameWorld/Enemies  as Node2D
	GlobalRefs.drop_holder = $GameWorld/Drops as Node2D
	GlobalRefs.gui_holder = $MainGUI as Control
	GlobalRefs.player_camera_controller = $GameWorld/Player/PlayerCameraController as PhantomCamera2D



