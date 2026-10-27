class_name InputHelper


static func add_to_keybind(event: Dictionary, keybind_info: Array, is_controller: bool) -> void:
	var input_group: String = keybind_info[0] as String
	var input_key: String = keybind_info[1] as String
	
	var keybind_array: Array = InputSettingsHelper.get_setting_partial(input_group, input_key, is_controller)

	# ensure there aren't duplicate inputs
	var duplicate_found: bool = false
	for keybind: Dictionary in keybind_array:
		if event.hash() == keybind.hash():
			duplicate_found = true
			break
	
	if not duplicate_found: 
		keybind_array.append(event)
		InputMapHelper.add_input(input_key, event, input_group)
		InputSettingsHelper.change_setting(input_group, input_key, keybind_array, is_controller)


static func reset_keybind(keybind_info: Array, is_controller: bool) -> void:
	var input_group: String = keybind_info[0] as String
	var input_key: String = keybind_info[1] as String
	
	InputMapHelper.clear_input(input_key)
	InputSettingsHelper.change_setting(input_group, input_key, [], is_controller)
	
	# if you clear the controller keybinds... it should still have the keyboard ones and vice versa
	var keybind_array: Array = []
	keybind_array += InputSettingsHelper.get_setting_partial(input_group, input_key, not is_controller)
	InputMapHelper.add_input_from_array(input_key, keybind_array, input_group)
