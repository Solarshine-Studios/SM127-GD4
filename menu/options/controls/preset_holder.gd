class_name PresetHolder
extends HBoxContainer


@onready var preset_loader: PresetLoader = get_parent()
@export var preset_paths: Array[String]
@export var is_controller: bool = false


func _ready() -> void:
	for index: int in range(get_child_count()):
		if preset_paths.size() < index:
			printerr("Preset paths size is lower than amount of children! Some buttons won't work!")
			return
		
		var button: Button = get_child(index)
		button.pressed.connect(preset_loader.load_preset.bind(preset_paths[index], is_controller))
