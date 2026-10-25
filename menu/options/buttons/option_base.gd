@tool
@abstract
extends VBoxContainer
class_name OptionBase


@export var setting_section: String = ""
@export var setting_key: String = ""

var value: Variant = false
@onready var name_label: Label = %Name
@onready var value_label: Label = %Value

@export var option_name: String = "CFG_PLACEHOLDER":
	set(new_value):
		option_name = new_value
		(%Name as Label).text = tr(new_value)


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
	value_label.text = str(value)


func _get_default_value() -> Variant:
	return null
