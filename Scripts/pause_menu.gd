extends Control

@onready var pause_container: PanelContainer = $PauseContainer
@onready var settings_container: VBoxContainer = $SettingsContainer
@onready var settings_menu: VBoxContainer = $SettingsContainer/SettingsMenu
@onready var credits_container: HBoxContainer = $CreditsContainer


func _ready() -> void:
	SettingsManager.apply_video_settings()

func _on_resume_pressed() -> void:
	await get_tree().process_frame
	GlobalRefs.main_scene_node.toggle_pause()




func _on_settings_pressed() -> void:
	pause_container.hide()
	settings_container.show()


func _on_restart_pressed() -> void:
	GlobalRefs.main_scene_node.toggle_pause()
	get_tree().reload_current_scene.call_deferred()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_cancel_pressed() -> void:
	SettingsManager.apply_video_settings()
	SettingsManager.apply_audio_settings()
	pause_container.show()
	settings_container.hide()


func _on_settings_apply_pressed() -> void:
	SettingsManager.save_video_settings(settings_menu.video_settings)
	SettingsManager.save_audio_settings(settings_menu.audio_settings)
	pause_container.show()
	settings_container.hide()



func _on_credits_pressed() -> void:
	pause_container.hide()
	credits_container.show()


func _on_credits_return_pressed() -> void:
	pause_container.show()
	credits_container.hide()

