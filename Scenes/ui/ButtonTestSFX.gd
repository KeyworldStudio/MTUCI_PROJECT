extends Button

@onready var test_audio_sound = %AudioStreamPlayer2D as AudioStreamPlayer2D

func _ready():
	pressed.connect(on_button_pressed)

func on_button_pressed():
	test_audio_sound.play()
