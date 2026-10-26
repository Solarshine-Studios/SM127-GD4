@tool
extends OptionBase


@export var default_value: int = 0
@export var options: Array[String]

@onready var option_button: OptionButton = %OptionButton


func _ready() -> void:
	super()
	if not Engine.is_editor_hint():
		for option: String in options:
			option_button.add_item(option)
	_update_value()


func item_selected(index: int) -> void:
	change_setting(index)


func _update_value() -> void:
	super()
	option_button.selected = value


func _get_default_value() -> int:
	return default_value
