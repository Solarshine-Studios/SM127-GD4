class_name Remapper
extends TabContainerSound

const INPUT_WAIT_TEXT: String = "CTRL_WAITING"

@onready var on_sound: AudioStreamPlayer = %OnSound
@export var categories: Array[Container]
@export var current_category: Container
var listening_keybind: KeybindButton
var is_controller: bool = false


func _ready() -> void:
	super()
	is_controller = LastInputDevice.last_input_type == LastInputDevice.InputType.Controller
	load_all_keybinds()


func _input(event: InputEvent) -> void:
	if not is_instance_valid(listening_keybind): return
	if not InputEventHelper.is_valid_input_event(event.get_class(), is_controller): return
	if listening_keybind.force_ctrl and event is InputEventKey:
		if (event as InputEventKey).keycode == KEY_CTRL: return
	
	var action: Dictionary = InputEventHelper.serialize_event(event)
	if action == InputEventHelper.EMPTY_DICTIONARY:
		return
	
	InputHelper.add_to_keybind(
		action, 
		[listening_keybind.input_group, listening_keybind.input_key], 
		is_controller
	)
	
	get_viewport().set_input_as_handled()
	on_sound.play()
	
	listening_keybind.change_button_text()
	listening_keybind = null


func reset_keybind(keybind: KeybindButton) -> void:
	InputHelper.reset_keybind(
		[keybind.input_group, keybind.input_key],
		is_controller
	)
	keybind.change_button_text()


func load_all_keybinds() -> void:
	for category: Container in categories:
		load_category(category)


func load_category(category: Container) -> void:
	for child: Node in category.get_children():
		if child is KeybindButton:
			var keybind: KeybindButton = child
			var keybind_array: Array = [] 
			keybind_array += InputSettingsHelper.get_setting(keybind.input_group, keybind.input_key)
			InputMapHelper.clear_input(keybind.input_key)
			InputMapHelper.add_input_from_array(keybind.input_key, keybind_array, keybind.input_group)
			
			keybind.is_controller = is_controller
			keybind.change_button_text()


func start_listening(keybind: KeybindButton, parent: GridContainer) -> void:
	for child: Node in parent.get_children():
		if child is KeybindButton:
			var keybind_button: KeybindButton = child
			keybind_button.change_button_text()
	
	keybind.change_button_text(tr(INPUT_WAIT_TEXT))
	
	# let's not pick up the key that pressed the button
	await get_tree().process_frame
	listening_keybind = keybind


func switch_device_type(_is_controller: bool) -> void:
	is_controller = _is_controller
	listening_keybind = null
	load_all_keybinds()
