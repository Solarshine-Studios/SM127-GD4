@tool
extends OptionBase

const CHECK_CHECKED: Texture = preload("res://global/assets/icons/CheckChecked.svg")
const CHECK_UNCHECKED: Texture = preload("res://global/assets/icons/CheckUnchecked.svg")

@onready var on_sound: AudioStreamPlayer = owner.get_node("%OnSound")
@onready var off_sound: AudioStreamPlayer = owner.get_node("%OffSound")

@onready var button: ButtonSound = %Button
@onready var icon: TextureRect = %Icon

@export var default_value: bool = false


func pressed() -> void:
	change_setting(not value)


func set_option_name(new_value: StringName) -> void:
	option_name = new_value
	var _button: ButtonSound = %Button
	_button.text = tr(new_value)
	_button.handle_spaces()


func _update_value() -> void:
	super()
	icon.texture = CHECK_CHECKED if value else CHECK_UNCHECKED
	button.click_sound = on_sound if value else off_sound


func _get_default_value() -> bool:
	return default_value
