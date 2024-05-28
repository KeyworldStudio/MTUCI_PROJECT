extends CanvasGroup

@export var anim_player: AnimationPlayer

func start_animation() -> void:
	anim_player.play("Open")
