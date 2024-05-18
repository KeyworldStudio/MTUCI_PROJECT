class_name SettingsMenu
extends Control


@onready var mini_exit_button = %ButtonMiniExit as Button


signal exit_settings_menu


func _ready():
	mini_exit_button.pressed.connect(on_miniExit_pressed)
	set_process(false)


func on_miniExit_pressed() -> void:
	exit_settings_menu.emit()
	set_process(false)
