extends Node2D

func _ready() -> void:
	hide()

func _on_tutorial_text_enabler_body_entered(body: Node2D) -> void:
	show()
