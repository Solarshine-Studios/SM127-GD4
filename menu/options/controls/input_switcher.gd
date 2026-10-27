extends HBoxContainer

const SELECTED_THEME: String = "SettingsButtonSelected"
const UNSELECTED_THEME: String = "SettingsButton"

@onready var keyboard_button: ButtonHoverVertical = $Keyboard
@onready var controller_button: ButtonHoverVertical = $Controller
@onready var touch_button: ButtonHoverVertical = $Touch
@onready var remapper: Remapper = %Remapper
@export var preset_loaders: Array[PresetLoader]


enum InputType {
	Keyboard,
	Controller,
	Touch
}


func _ready() -> void:
	keyboard_button.pressed.connect(switch_input.bind(InputType.Keyboard))
	controller_button.pressed.connect(switch_input.bind(InputType.Controller))
	touch_button.pressed.connect(switch_input.bind(InputType.Touch))


func switch_input(input_type: InputType) -> void:
	keyboard_button.theme_type_variation = SELECTED_THEME if (input_type == InputType.Keyboard) else UNSELECTED_THEME
	controller_button.theme_type_variation = SELECTED_THEME if (input_type == InputType.Controller) else UNSELECTED_THEME
	touch_button.theme_type_variation = SELECTED_THEME if (input_type == InputType.Touch) else UNSELECTED_THEME
	
	if input_type == InputType.Touch:
		## TODO: add touch remapping
		remapper.hide()
	else:
		remapper.show()
		for preset_loader: PresetLoader in preset_loaders:
			var keyboard_holder: PresetHolder = preset_loader.get_node("Keyboard")
			var controller_holder: PresetHolder = preset_loader.get_node("Controller")
			keyboard_holder.visible = (input_type == InputType.Keyboard)
			controller_holder.visible = (input_type == InputType.Controller)
		
		remapper.switch_device_type(input_type == InputType.Controller)
