extends Node2D

@onready var test_player_ref = GlobalRefs.player_node

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug(GlobalRefs.player_node)
	test_player_ref = GlobalRefs.player_node
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print_debug(test_player_ref)
	pass
