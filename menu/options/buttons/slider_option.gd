@tool
extends OptionBase

@onready var slider: HSlider = $PanelContainer/HSlider
@export var default_value: float = 0
@export var min_val: float = 0
@export var max_val: float = 100
@onready var value_label: Label = %Value


func slider_changed(new_val: float) -> void:
	value = new_val
	change_setting(value)


func _ready() -> void:
	super()
	slider.min_value = min_val
	slider.max_value = max_val
	slider.set_value_no_signal(value)


func _update_value() -> void:
	value_label.text = str(int(value))
	slider.set_value_no_signal(value)


func _get_default_value() -> float:
	return default_value
