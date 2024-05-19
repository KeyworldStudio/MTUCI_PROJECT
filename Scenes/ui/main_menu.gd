class_name MainMenu
extends Control


@onready var start_button = %StartButton as Button
@onready var exit_button = %ExitButton as Button
@onready var settings_button = %SettingsButton as Button
@onready var settings_menu = $Settings_Menu as SettingsMenu
@onready var margin_container = $TextureRect/MarginContainer as MarginContainer
@onready var first_level = preload("res://test_ms.tscn") as PackedScene

func _ready():
	handle_connecting_signals()


func on_start_pressed() ->void:
	get_tree().change_scene_to_packed(first_level)


func on_settings_pressed() ->void:
	margin_container.visible = false
	settings_menu.set_process(true)
	settings_menu.visible = true

func on_exit_pressed() ->void:
	get_tree().quit()


func on_exit_settings_menu() ->void:
	margin_container.visible = true
	settings_menu.visible = false


func handle_connecting_signals() -> void:
	start_button.pressed.connect(on_start_pressed)
	settings_button.pressed.connect(on_settings_pressed)
	exit_button.pressed.connect(on_exit_pressed)
	settings_menu.exit_settings_menu.connect(on_exit_settings_menu)


