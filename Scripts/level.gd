class_name LevelBase
extends Node2D

@export var tilemap_node: TileMap


func _ready():
	var playercam: = GlobalRefs.player_camera_controller as PhantomCamera2D
	if tilemap_node:
		playercam.set_limit_node(tilemap_node)
