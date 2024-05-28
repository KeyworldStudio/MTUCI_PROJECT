class_name LevelBase
extends Node2D

@export var top_left_limit: Node2D
@export var bottom_right_limit: Node2D


func _ready():
	var playercam = GlobalRefs.player_camera_controller
	if top_left_limit:
		playercam.set_limit(SIDE_LEFT,top_left_limit.global_position.x)
		playercam.set_limit(SIDE_TOP,top_left_limit.global_position.y)
	
	if bottom_right_limit:
		playercam.set_limit(SIDE_RIGHT,bottom_right_limit.global_position.x)
		playercam.set_limit(SIDE_BOTTOM,bottom_right_limit.global_position.y)
