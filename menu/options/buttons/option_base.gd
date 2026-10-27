@tool
@abstract
extends Container
class_name OptionBase


@export var setting_section: StringName
@export var setting_key: StringName

var value: Variant = false

@export var option_name: StringName = "CFG_PLACEHOLDER":
	set = set_option_name


## new functions
func reload_value(key: String, new_value: Variant = null) -> void:
	if Engine.is_editor_hint(): return
	if key != setting_key: return
	
	value = new_value
	if value == null:
		value = LocalSettings.load_setting(setting_section, setting_key, _get_default_value())
	_update_value()


func change_setting(new_value: Variant) -> void:
	if !Engine.is_editor_hint():
		LocalSettings.change_setting(setting_section, setting_key, new_value)


func set_option_name(new_value: StringName) -> void:
	option_name = new_value
	(%Name as Label).text = tr(new_value)


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		set_option_name(option_name)


## built in functions
func _ready() -> void:
	value = _get_default_value()
	if !Engine.is_editor_hint():
		LocalSettings.setting_changed.connect(reload_value)
		reload_value(setting_key)
	# just running the set function
	option_name = option_name


## override these
func _update_value() -> void:
	pass


func _get_default_value() -> Variant:
	return null
