extends Node

const CATEGORIES: Array[String] = [
	"General",
	"Audio",
	"Header"
]

func _ready() -> void:
	var config: ConfigFile = LocalSettings.config
	
	LocalSettings.setting_changed.connect(change_setting)
	for category in CATEGORIES:
		if config.has_section(category):
			load_category(category, config)
	
	if config.has_section_key("Controls (Player 1)", "rumble"):
		change_setting("rumble", LocalSettings.load_setting("Controls (Gameplay)", "rumble", true))
	
	# we can initialize this here for now i suppose
	if not config.has_section_key("Header", "game_version"):
		if DirAccess.dir_exists_absolute("user://levels"):
			game_version_mismatch = true
			LocalSettings.change_setting("Header", "game_version", "0.7.0")
		else:
			var cur_version: String = ProjectSettings.get_setting("application/config/version")
			LocalSettings.change_setting("Header", "game_version", cur_version)

func load_category(category: String, config: ConfigFile) -> void:
	for key in config.get_section_keys(category):
		if config.has_section_key(category, key):
			change_setting(
				key, LocalSettings.load_setting(category, key, null)
			)



func change_setting(key: String, new_value: Variant) -> void:
	match key:
		# General
		"v_sync":
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if new_value else DisplayServer.VSYNC_DISABLED)
		"fps_cap":
			match new_value:
				0:
					Engine.max_fps = 30
				1:
					Engine.max_fps = 40
				2:
					Engine.max_fps = 50
				3:
					Engine.max_fps = 60
				4:
					Engine.max_fps = 0
		
		"rumble":
			LastInputDevice.do_rumble = new_value
		
		"window_mode":
			match new_value:
				0:
					get_window().mode = Window.MODE_WINDOWED
					get_window().borderless = false
				1:
					get_window().mode = Window.MODE_WINDOWED
					get_window().borderless = true
				2:
					get_window().mode = Window.MODE_FULLSCREEN
		
		"scale_mode":
			var main_scene: MainScene = get_tree().get_first_node_in_group("main_scene")
			main_scene.update_container_sizing(new_value)
		
		"master_volume":
			var bus_index: int = AudioServer.get_bus_index("Master")
			var volume_db: float = linear_to_db(float(new_value) / 100)
			AudioServer.set_bus_volume_db(bus_index, volume_db)
			last_master_volume = new_value

		"bgm_volume":
			var bus_index: int = AudioServer.get_bus_index("Music")
			var volume_db: float = linear_to_db(float(new_value) / 100)
			AudioServer.set_bus_volume_db(bus_index, volume_db)
			if new_value > 0: last_non_muted_bgm = new_value

		"sfx_volume":
			var bus_index: int = AudioServer.get_bus_index("Sounds")
			var volume_db: float = linear_to_db(float(new_value) / 100)
			AudioServer.set_bus_volume_db(bus_index, volume_db)
		
		# Header
		"game_version":
			var cur_version: String = ProjectSettings.get_setting("application/config/version")
			if new_value != cur_version:
				handle_version_upgrade(new_value)


## related to various hotkeys
var last_master_volume: float = 75.0
var last_non_muted_bgm: float = 70.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		LocalSettings.change_setting("General", "window_mode", 2 if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN else 0)
	
	var current_scene: Node = get_tree().current_scene
	if current_scene is not Editor:
		if event.is_action_pressed("volume_up"):
			LocalSettings.change_setting("Audio", "master_volume", last_master_volume + 5)
		if event.is_action_pressed("volume_down"):
			LocalSettings.change_setting("Audio", "master_volume", last_master_volume - 5)
		
	if event.is_action_pressed("mute"):
		var current_vol: float = LocalSettings.load_setting("Audio", "bgm_volume", 70)
		LocalSettings.change_setting("Audio", "bgm_volume", 0.0 if current_vol > 0.0 else last_non_muted_bgm)


## when you come from a version that's lower or higher than your current one
var game_version_mismatch: bool
func handle_version_upgrade(old_version: String) -> void:
	var cur_version: String = ProjectSettings.get_setting("application/config/version")
	print("Version mismatch detected! Old version: %s, New version: %s" % [old_version, cur_version])
	game_version_mismatch = true
	if FileAccess.file_exists("user://level_list/converted"):
		LocalSettings.change_setting("Header", "game_version", cur_version)
