extends HBoxContainer


const SELECTED_THEME: String = "SettingsButtonSelected"
const UNSELECTED_THEME: String = "SettingsButton"

@onready var keyboard_button: ButtonHoverVertical = $Keyboard
@onready var controller_button: ButtonHoverVertical = $Controller
@onready var touch_button: ButtonHoverVertical = $Touch
@onready var remapper: Remapper = %Remapper
@onready var rumble: OptionBase = %Rumble
@export var preset_loaders: Array[PresetLoader]


func _ready() -> void:
	keyboard_button.pressed.connect(switch_input.bind(LastInputDevice.InputType.Keyboard))
	controller_button.pressed.connect(switch_input.bind(LastInputDevice.InputType.Controller))
	touch_button.pressed.connect(switch_input.bind(LastInputDevice.InputType.Touch))
	(owner as Screen).screen_opened.connect(screen_opened)


func screen_opened() -> void:
	switch_input(LastInputDevice.last_input_type)


func switch_input(input_type: LastInputDevice.InputType) -> void:
	keyboard_button.theme_type_variation = SELECTED_THEME if (input_type == LastInputDevice.InputType.Keyboard) else UNSELECTED_THEME
	controller_button.theme_type_variation = SELECTED_THEME if (input_type == LastInputDevice.InputType.Controller) else UNSELECTED_THEME
	touch_button.theme_type_variation = SELECTED_THEME if (input_type == LastInputDevice.InputType.Touch) else UNSELECTED_THEME
	
	if input_type == LastInputDevice.InputType.Touch:
		## TODO: add touch remapping
		remapper.hide()
	else:
		remapper.show()
		for preset_loader: PresetLoader in preset_loaders:
			var keyboard_holder: PresetHolder = preset_loader.get_node("Keyboard")
			var controller_holder: PresetHolder = preset_loader.get_node("Controller")
			keyboard_holder.visible = (input_type == LastInputDevice.InputType.Keyboard)
			controller_holder.visible = (input_type == LastInputDevice.InputType.Controller)
		
		remapper.switch_device_type(input_type == LastInputDevice.InputType.Controller)
		rumble.visible = (input_type == LastInputDevice.InputType.Controller)
