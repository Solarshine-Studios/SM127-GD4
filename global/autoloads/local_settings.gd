extends Node
## Settings stored on the user's system.

signal setting_changed(key: String, new_value: Variant)

const FILE_PATH: String = "user://settings.cfg"
var config: ConfigFile = ConfigFile.new()


func _init() -> void:
	if not FileAccess.file_exists(FILE_PATH):
		config.save(FILE_PATH)

	var err: Error = config.load(FILE_PATH)
	if err != OK:
		push_error("Error loading config file!")


## Load a setting [param key] at a category [param section] in the config file.
func load_setting(section: String, key: String, default: Variant) -> Variant:
	return config.get_value(section, key, default)


## Update a setting [param key] at a category [param section],
## with a new [param value] in the config file.
func change_setting(section: String, key: String, value: Variant, suppress_signal: bool = false) -> void:
	_apply_setting(section, key, value, suppress_signal)
	config.save(FILE_PATH)


## Returns whether or not a key exists and has a value.
func has_setting(section: String, key: String) -> void:
	return config.has_section_key(section, key)


## Applies the setting change to the config and emits the [signal setting_changed] signal.
func _apply_setting(section: String, key: String, value: Variant, suppress_signal: bool = false) -> void:
	config.set_value(section, key, value)

	if not suppress_signal:
		emit_signal(&"setting_changed", key, value)
