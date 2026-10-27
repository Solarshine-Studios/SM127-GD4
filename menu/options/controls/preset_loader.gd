class_name PresetLoader
extends HBoxContainer


@onready var remapper: Remapper = %Remapper
@export var category_init: StringName
@export var default_preset_path: String
@export var default_controller_path: String

var loading_defaults: bool = true

# initialize controls
func _ready() -> void:
	# will load preset if category doesn't
	# exist in the config file yet
	if not LocalSettings.config.has_section(category_init):
		print(category_init + " doesn't exist, loading preset")
		load_preset(default_preset_path, false, category_init)
	
	var controller_category: String = (category_init + InputSettingsHelper.get_group_suffix(true))
	if not LocalSettings.config.has_section(controller_category):
		print(controller_category + " doesn't exist, loading preset")
		load_preset(default_controller_path, true, category_init)
		
	loading_defaults = false


func load_preset(preset_path: String, is_controller: bool = false, category: String = "") -> void:
	var config: ConfigFile = ConfigFile.new()
	
	var err: Error = config.load(preset_path)
	if err != OK:
		printerr("Error loading config file!")
		return
	
	if category == "":
		var first_button: KeybindButton = remapper.current_category.get_child(0)
		category = first_button.input_group
	
	for key: String in config.get_section_keys("Preset"):
		var value: Variant = config.get_value("Preset", key, [])
		if value is Array:
			InputSettingsHelper.change_setting(category, key, value, is_controller)
		else:
			LocalSettings.change_setting(category + InputSettingsHelper.get_group_suffix(is_controller), key, value)
	
	# we load defaults on ready, which is before
	# remapper loads; and this line causes errors then
	# so in that situation we let it load on its own
	if not loading_defaults:
		remapper.load_all_keybinds()
