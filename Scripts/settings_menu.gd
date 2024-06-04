extends Control


@onready var brightness_slider: HSlider = $TabContainer/VIDEO/VBoxContainer/BrightnessSlider/Brightness
@onready var vsync_tickbox: CheckBox = $TabContainer/VIDEO/VBoxContainer/HBoxContainer/VSync
@onready var full_screen_tickbox: CheckBox = $TabContainer/VIDEO/VBoxContainer/HBoxContainer/FullScreen

@onready var sfx_slider: HSlider = $TabContainer/Audio/VBoxContainer/SoundSlider/Sound
@onready var sfx_test: AudioStreamPlayer = $TabContainer/Audio/VBoxContainer/SoundSlider/Sound/SFXTest

@onready var master_slider: HSlider = $TabContainer/Audio/VBoxContainer/MasterSlider/Master
@onready var music_slider: HSlider = $TabContainer/Audio/VBoxContainer/MusicSlider/Music
@onready var mfx_test: AudioStreamPlayer = $TabContainer/Audio/VBoxContainer/MusicSlider/Music/MFXTest

@onready var mute_music_tickbox: CheckBox = $TabContainer/Audio/VBoxContainer/HBoxContainer/MuteMusic
@onready var mute_sound_tickbox: CheckBox = $TabContainer/Audio/VBoxContainer/HBoxContainer/MuteSound

var sound_test: bool = false

var video_settings: = {}
var audio_settings: = {}


func _on_visibility_changed() -> void:
	update_video_setting_controls()
	update_audio_setting_controls()


func update_video_setting_controls() -> void:
	video_settings = SettingsManager.load_video_settings()
	brightness_slider.value = video_settings["Brightness"]
	vsync_tickbox.button_pressed = video_settings["VSync"]
	full_screen_tickbox.button_pressed = video_settings["FullScreen"]
	
	

func update_audio_setting_controls() -> void:
	sound_test = false
	
	await get_tree().process_frame
	
	audio_settings = SettingsManager.load_audio_settings()
	sfx_slider.value = audio_settings["Sound"]
	music_slider.value = audio_settings["Music"]
	master_slider.value = audio_settings["Master"]
	mute_music_tickbox.button_pressed = audio_settings["MuteMusic"]
	mute_sound_tickbox.button_pressed = audio_settings["MuteSound"]
	
	await get_tree().process_frame
	
	sound_test = true

func _on_brightness_value_changed(value: float) -> void:
	video_settings["Brightness"] = value
	SettingsManager.apply_brightness(video_settings["Brightness"])


func _on_v_sync_toggled(toggled_on: bool) -> void:
	video_settings["VSync"] = toggled_on
	SettingsManager.apply_vsync(video_settings["VSync"])


func _on_full_screen_toggled(toggled_on: bool) -> void:
	video_settings["FullScreen"] = toggled_on
	SettingsManager.apply_fullscreen(video_settings["FullScreen"])


func _on_sound_value_changed(value: float) -> void:
	audio_settings["Sound"] = value
	SettingsManager.apply_sfx_volume(audio_settings["Sound"])
	
	if sound_test:
		sfx_test.play()
	

func _on_music_value_changed(value: float) -> void:
	audio_settings["Music"] = value
	SettingsManager.apply_music_volume(audio_settings["Music"])
	
	if sound_test:
		mfx_test.play()


func _on_master_value_changed(value: float) -> void:
	audio_settings["Master"] = value
	SettingsManager.apply_master_volume(audio_settings["Master"])
	if sound_test:
		sfx_test.play()
		mfx_test.play()
	


func _on_mute_music_toggled(toggled_on: bool) -> void:
	audio_settings["MuteMusic"] = toggled_on
	SettingsManager.apply_music_mute(audio_settings["MuteMusic"])


func _on_mute_sound_toggled(toggled_on: bool) -> void:
	audio_settings["MuteSound"] = toggled_on
	SettingsManager.apply_sfx_mute(audio_settings["MuteSound"])


func _on_reset_audio_pressed() -> void:
	SettingsManager.reset_audio_settings()
	update_audio_setting_controls()


func _on_reset_video_pressed() -> void:
	SettingsManager.reset_video_settings()
	update_video_setting_controls()
