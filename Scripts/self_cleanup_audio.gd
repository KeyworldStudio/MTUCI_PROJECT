class_name SelfCleanupAudio
extends AudioStreamPlayer2D

var is_copy: bool = false
func _ready() -> void:
	if !finished.is_connected(_on_finished):
		finished.connect(_on_finished)

func start():
	if !is_copy:
		var copy = duplicate()
		GlobalRefs.game_world_node.add_child(copy)
		copy.is_copy = true
		copy.global_transform = global_transform
		copy.play()
	

func _on_finished():
	queue_free()


