extends Node

@onready var config = ConfigFile.new()
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
const SETTINGS_FILE_PATH = "user://settings.ini"

var base_glow_intensity: float = 0.8
var base_brightness: float = 1.0


func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		reset_audio_settings()
		
		
	else:
		config.load(SETTINGS_FILE_PATH)
		apply_video_settings()
		apply_audio_settings()


func reset_audio_settings() -> void:
	config.set_value("Audio", "Master", 1.0)
	config.set_value("Audio", "Sound", 1.0)
	config.set_value("Audio", "Music", 1.0)
	config.set_value("Audio", "MuteSound", false)
	config.set_value("Audio", "MuteMusic", false)
	
	config.save(SETTINGS_FILE_PATH)


func reset_video_settings() -> void:
	config.set_value("Video", "Brightness", 1.0)
	config.set_value("Video", "FullScreen", false)
	config.set_value("Video", "VSync", true)
	
	config.save(SETTINGS_FILE_PATH)

func apply_video_settings():
	var video_settings = load_video_settings()
	apply_brightness(video_settings["Brightness"])
	apply_vsync(video_settings["VSync"])
	apply_fullscreen(video_settings["FullScreen"])


func apply_audio_settings():
	var audio_settings = load_audio_settings()
	apply_master_volume(audio_settings["Master"])
	apply_sfx_volume(audio_settings["Sound"])
	apply_music_volume(audio_settings["Music"])
	apply_sfx_mute(audio_settings["MuteSound"])
	apply_music_mute(audio_settings["MuteMusic"])



func save_audio_settings(values: Dictionary) -> void:
	for key in values.keys():
		config.set_value("Audio", key, values[key])
	config.save(SETTINGS_FILE_PATH)


func save_video_settings(values: Dictionary) -> void:
	for key in values.keys():
		config.set_value("Video", key, values[key])
	config.save(SETTINGS_FILE_PATH)


func load_audio_settings() -> Dictionary:
	var audio_settings = {}
	for key in config.get_section_keys("Audio"):
		audio_settings[key] = config.get_value("Audio", key)
	
	return audio_settings


func load_video_settings() -> Dictionary:
	var video_settings = {}
	for key in config.get_section_keys("Video"):
		video_settings[key] = config.get_value("Video", key)
	
	return video_settings

func apply_brightness(value: float) -> void:
	await get_tree().process_frame
	var world_env = GlobalRefs.world_environment
	world_env.environment.adjustment_brightness = base_brightness * value
	world_env.environment.glow_intensity = base_glow_intensity / value


func apply_vsync(value: bool) -> void:
	await get_tree().process_frame
	if value:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func apply_fullscreen(value: bool) -> void:
	await get_tree().process_frame
	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func apply_sfx_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(SFX_BUS_ID,linear_to_db(value))


func apply_music_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID,linear_to_db(value))


func apply_master_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(MASTER_BUS_ID,linear_to_db(value))

func apply_sfx_mute(value: bool):
	AudioServer.set_bus_mute(SFX_BUS_ID,value)

func apply_music_mute(value: bool):
	AudioServer.set_bus_mute(MUSIC_BUS_ID,value)
