class_name InputMapHelper


const EMPTY_DICTIONARY: Dictionary = {}


## functions that edit the actual control bindings
static func add_input(action: String, event_dict: Dictionary, input_group: String) -> void:
	var input_name: String = action
	
	if not InputMap.has_action(input_name):
		InputMap.add_action(input_name, InputEventHelper.DEADZONE)
	
	if event_dict == EMPTY_DICTIONARY: return
	
	var input_event: InputEvent = InputEventHelper.deserialize_event(event_dict)
	if not is_instance_valid(input_event):
		return
	
	if InputEventHelper.is_controller_input(event_dict):
		input_event.device = InputSettingsHelper.get_device(input_group)
	
	InputMap.action_add_event(input_name, input_event)
	## fix triggers not working...
	if OS.get_name() == "Android":
		InputMap.action_set_deadzone(input_name, 0.6)


static func clear_input(action: String) -> void:
	var input_name: String = action
	if InputMap.has_action(input_name):
		InputMap.action_erase_events(input_name)


static func add_input_from_array(action: String, keybind_array: Array, input_group: String) -> void:
	# just want to create the inputmap actions even
	# if it's unbound, to prevent any errors
	add_input(action, EMPTY_DICTIONARY, input_group)
	for event_dict: Dictionary in keybind_array:
		add_input(action, event_dict, input_group)
