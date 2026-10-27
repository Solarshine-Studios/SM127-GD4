class_name InputEventHelper


const EMPTY_DICTIONARY: Dictionary = {}

const KEYBOARD: int = 0
const MOUSE: int = 1
const JOYPAD_BUTTON: int = 2
const JOYPAD_MOTION: int = 3

const DEADZONE: float = 0.25
const ANY_DEVICE: int = -1


## convert between inputevent and dictionary, for
## storing input actions into a save file
static func deserialize_event(dictionary: Dictionary) -> InputEvent:
	var input_event: InputEvent = null
	match dictionary["input_type"]:
		KEYBOARD:
			var key_event := InputEventKey.new()
			
			if not dictionary.has("key"):
				return null
			
			var key_id: Key = OS.find_keycode_from_string(dictionary.key)
			key_event.keycode = key_id
			input_event = key_event
		
		MOUSE:
			var mouse_event := InputEventMouseButton.new()
			mouse_event.button_index = dictionary.button_index
			input_event = mouse_event
		
		JOYPAD_BUTTON:
			var joy_button := InputEventJoypadButton.new()
			joy_button.button_index = dictionary.button_index
			input_event = joy_button
		
		JOYPAD_MOTION:
			var joy_motion := InputEventJoypadMotion.new()
			joy_motion.axis = dictionary.axis
			joy_motion.axis_value = dictionary.axis_value
			input_event = joy_motion
	
	if input_event:
		input_event.device = ANY_DEVICE
	return input_event


static func serialize_event(event: InputEvent) -> Dictionary:
	var dictionary: Dictionary = {}
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		return EMPTY_DICTIONARY
	
	match event.get_class():
		"InputEventKey":
			dictionary["input_type"] = KEYBOARD
			dictionary["key"] = OS.get_keycode_string((event as InputEventKey).keycode)

		"InputEventMouseButton":
			dictionary["input_type"] = MOUSE
			dictionary["button_index"] = (event as InputEventMouseButton).button_index
		
		"InputEventJoypadButton":
			dictionary["input_type"] = JOYPAD_BUTTON
			dictionary["button_index"] = (event as InputEventJoypadButton).button_index
		
		"InputEventJoypadMotion":
			if abs((event as InputEventJoypadMotion).axis_value) > DEADZONE:
				dictionary["input_type"] = JOYPAD_MOTION
				dictionary["axis"] = (event as InputEventJoypadMotion).axis
				dictionary["axis_value"] = 1.0
			else:
				return EMPTY_DICTIONARY
	
	return dictionary


static func is_valid_input_event(event_class: String, is_controller: bool) -> bool:
	match event_class:
		"InputEventKey":
			if not is_controller: return true
		
		"InputEventMouseButton":
			if not is_controller: return true
		
		"InputEventJoypadButton":
			if is_controller: return true
		
		"InputEventJoypadMotion":
			if is_controller: return true
	
	return false


static func is_controller_input(event_dict: Dictionary) -> bool:
	if not "input_type" in event_dict: return false
	return event_dict.input_type == JOYPAD_BUTTON or event_dict.input_type == JOYPAD_MOTION
	

## For getting human-readable names from button_index variables.
const UNKNOWN: String = "Unknown"
const MOUSE_BUTTONS: Array[String] = [
	UNKNOWN,
	"Left Click",
	"Right Click",
	"Middle Click",
	"Wheel Up",
	"Wheel Down",
	"Wheel Left",
	"Wheel Right",
	"Click 4",
	"Click 5"
]
const JOY_BUTTONS_XBOX: Array[String] = [
	"A",
	"B",
	"X",
	"Y",
	"LB",
	"RB",
	"LT",
	"RT",
	"LS Click",
	"RS Click",
	"View",
	"Menu",
	"Up",
	"Down",
	"Left",
	"Right",
	"Logo",
	"Misc",
	"Paddle 1",
	"Paddle 2",
	"Paddle 3",
	"Paddle 4",
	"Touchpad"
]
const JOY_BUTTONS_NINTENDO: Array[String] = [
	"B",
	"A",
	"Y",
	"X",
	"L",
	"R",
	"ZL",
	"ZR",
	"LS Click",
	"RS Click",
	"Minus",
	"Plus",
	"Up",
	"Down",
	"Left",
	"Right",
	"Home",
	"Capture",
	"Paddle 1",
	"Paddle 2",
	"Paddle 3",
	"Paddle 4",
	"Touchpad"
]
const JOY_BUTTONS_PS: Array[String] = [
	"Cross",
	"Circle",
	"Square",
	"Triangle",
	"L1",
	"R1",
	"L2",
	"R2",
	"L3",
	"R3",
	"Create",
	"Options",
	"Up",
	"Down",
	"Left",
	"Right",
	"Logo",
	"Misc",
	"Paddle 1",
	"Paddle 2",
	"Paddle 3",
	"Paddle 4",
	"Touchpad"
]
const JOY_AXIS_XBOX: Array[String] = [
	"LS Left",
	"LS Right",
	
	"LS Up",
	"LS Down",
	
	"RS Left",
	"RS Right",
	
	"RS Up",
	"RS Down",
	
	"Axis 4-",
	"Axis 4+",

	"Axis 5-",
	"Axis 5+",
	
	"LT Release",
	"LT",
	
	"RT Release",
	"RT",

	"Axis 8-",
	"Axis 8+",

	"Axis 9-",
	"Axis 9+",

	"Axis 10-",
	"Axis 10+",
]
const JOY_AXIS_NINTENDO: Array[String] = [
	"LS Left",
	"LS Right",
	
	"LS Up",
	"LS Down",
	
	"RS Left",
	"RS Right",
	
	"RS Up",
	"RS Down",
	
	"Axis 4-",
	"Axis 4+",

	"Axis 5-",
	"Axis 5+",
	
	"ZL Release",
	"ZL",
	
	"ZR Release",
	"ZR",

	"Axis 8-",
	"Axis 8+",

	"Axis 9-",
	"Axis 9+",

	"Axis 10-",
	"Axis 10+",
]
const JOY_AXIS_PS: Array[String] = [
	"LS Left",
	"LS Right",
	
	"LS Up",
	"LS Down",
	
	"RS Left",
	"RS Right",
	
	"RS Up",
	"RS Down",
	
	"Axis 4-",
	"Axis 4+",

	"Axis 5-",
	"Axis 5+",
	
	"L2 Release",
	"L2",
	
	"R2 Release",
	"R2",

	"Axis 8-",
	"Axis 8+",

	"Axis 9-",
	"Axis 9+",

	"Axis 10-",
	"Axis 10+",
]
const TOUCH_NAMES: Dictionary = {
	"left": "Left",
	"right": "Right",
	"up": "Up",
	"down": "Down",
	"jump": "Jump",
	"spin": "Spin",
	"dive": "Dive",
	"gp": "Ground Pound",
	"gpcancel": "Ground Pound Cancel",
	"fludd": "Use F.L.U.D.D",
	"nozzles": "Switch Nozzles",
	"crouch": "Down",
	"interact": "Up",
}


static func get_touch_name(action: String) -> String:
	return TOUCH_NAMES.get(action, "Unknown")


static func get_singular_human_name(event: Dictionary) -> String:
	var string: String = ""
	match(event.input_type):
		KEYBOARD:
			string += event.get("key", "Invalid")
		
		MOUSE:
			if event.button_index < MOUSE_BUTTONS.size():
				string += MOUSE_BUTTONS[event.button_index]
			else:
				string += UNKNOWN
		
		JOYPAD_BUTTON:
			var chosen_array: Array[String] = []
			match LastInputDevice.last_layout_type:
				LastInputDevice.LayoutType.Xbox:
					chosen_array = JOY_BUTTONS_XBOX
				LastInputDevice.LayoutType.Nintendo:
					chosen_array = JOY_BUTTONS_NINTENDO
				LastInputDevice.LayoutType.PlayStation:
					chosen_array = JOY_BUTTONS_PS
			
			if event.button_index < chosen_array.size():
				string += chosen_array[event.button_index]
			else:
				string += UNKNOWN
		
		JOYPAD_MOTION:
			var event_index: int = event.axis * 2
			if event.axis_value > 0:
				event_index += 1

			var chosen_array: Array[String] = []
			match LastInputDevice.last_layout_type:
				LastInputDevice.LayoutType.Xbox:
					chosen_array = JOY_AXIS_XBOX
				LastInputDevice.LayoutType.Nintendo:
					chosen_array = JOY_AXIS_NINTENDO
				LastInputDevice.LayoutType.PlayStation:
					chosen_array = JOY_AXIS_PS
			
			string += chosen_array[event_index]
	
	return string


static func get_human_name(event_array: Array) -> String:
	var string: String = ""
	for event: Dictionary in event_array:
		if string != "": string += ", "
		string += get_singular_human_name(event)
		
	return string
