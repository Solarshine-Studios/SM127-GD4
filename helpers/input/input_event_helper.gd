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
				dictionary["axis_value"] = sign((event as InputEventJoypadMotion).axis_value)
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
	

const UNKNOWN: String = "INPUT_UNKNOWN"


## For getting human-readable names from button_index variables.
static func joypad_button_name(button: JoyButton, layout_type: LastInputDevice.LayoutType) -> String:
	# uniform across controllers
	match button:
		JOY_BUTTON_DPAD_UP: return trs("INPUT_UP")
		JOY_BUTTON_DPAD_DOWN: return trs("INPUT_DOWN")
		JOY_BUTTON_DPAD_LEFT: return trs("INPUT_LEFT")
		JOY_BUTTON_DPAD_RIGHT: return trs("INPUT_RIGHT")

		JOY_BUTTON_PADDLE1: return trs("INPUT_PADDLE") % "1"
		JOY_BUTTON_PADDLE2: return trs("INPUT_PADDLE") % "2"
		JOY_BUTTON_PADDLE3: return trs("INPUT_PADDLE") % "3"
		JOY_BUTTON_PADDLE4: return trs("INPUT_PADDLE") % "4"
		
		JOY_BUTTON_TOUCHPAD: return trs("INPUT_TOUCHPAD")
	
	match layout_type:
		LastInputDevice.LayoutType.Nintendo:
			match button:
				JOY_BUTTON_A: return trs("INPUT_GAMEPAD_B")
				JOY_BUTTON_B: return trs("INPUT_GAMEPAD_A")
				JOY_BUTTON_X: return trs("INPUT_GAMEPAD_Y")
				JOY_BUTTON_Y: return trs("INPUT_GAMEPAD_X")

				JOY_BUTTON_LEFT_SHOULDER: return trs("INPUT_NINTENDO_LEFT_SHOULDER")
				JOY_BUTTON_RIGHT_SHOULDER: return trs("INPUT_NINTENDO_RIGHT_SHOULDER")

				JOY_BUTTON_BACK: return trs("INPUT_NINTENDO_MINUS")
				JOY_BUTTON_START:return trs("INPUT_NINTENDO_PLUS")
				JOY_BUTTON_GUIDE: return trs("INPUT_NINTENDO_HOME")
				JOY_BUTTON_MISC1: return trs("INPUT_NINTENDO_CAPTURE")

				JOY_BUTTON_LEFT_STICK: return trs("INPUT_LEFT_STICK_CLICK")
				JOY_BUTTON_RIGHT_STICK: return trs("INPUT_RIGHT_STICK_CLICK")
		LastInputDevice.LayoutType.PlayStation:
			match button:
				JOY_BUTTON_A: return trs("INPUT_PS_CROSS")
				JOY_BUTTON_B: return trs("INPUT_PS_CIRCLE")
				JOY_BUTTON_X: return trs("INPUT_PS_SQUARE")
				JOY_BUTTON_Y: return trs("INPUT_PS_TRIANGLE")

				JOY_BUTTON_LEFT_SHOULDER: return trs("INPUT_PS_LEFT_SHOULDER")
				JOY_BUTTON_RIGHT_SHOULDER: return trs("INPUT_PS_RIGHT_SHOULDER")

				JOY_BUTTON_BACK: return trs("INPUT_PS_CREATE")
				JOY_BUTTON_START:return trs("INPUT_PS_OPTIONS")
				JOY_BUTTON_GUIDE: return trs("INPUT_PS_LOGO")
				JOY_BUTTON_MISC1: return trs("INPUT_PS_MISC")

				JOY_BUTTON_LEFT_STICK: return trs("INPUT_LEFT_STICK_CLICK_PS")
				JOY_BUTTON_RIGHT_STICK: return trs("INPUT_RIGHT_STICK_CLICK_PS")
		_:
			match button:
				JOY_BUTTON_A: return trs("INPUT_GAMEPAD_A")
				JOY_BUTTON_B: return trs("INPUT_GAMEPAD_B")
				JOY_BUTTON_X: return trs("INPUT_GAMEPAD_X")
				JOY_BUTTON_Y: return trs("INPUT_GAMEPAD_Y")

				JOY_BUTTON_LEFT_SHOULDER: return trs("INPUT_XBOX_LEFT_SHOULDER")
				JOY_BUTTON_RIGHT_SHOULDER: return trs("INPUT_XBOX_RIGHT_SHOULDER")

				JOY_BUTTON_BACK: return trs("INPUT_XBOX_VIEW")
				JOY_BUTTON_START: return trs("INPUT_XBOX_MENU")
				JOY_BUTTON_GUIDE: return trs("INPUT_XBOX_LOGO")
				JOY_BUTTON_MISC1: return trs("INPUT_XBOX_MISC")

				JOY_BUTTON_LEFT_STICK: return trs("INPUT_LEFT_STICK_CLICK")
				JOY_BUTTON_RIGHT_STICK: return trs("INPUT_RIGHT_STICK_CLICK")
	
	# if nothing else
	return trs("INPUT_BUTTON") % button


static func joypad_motion_name(axis: int, value: float, layout_type: LastInputDevice.LayoutType) -> String:
	match axis:
		JOY_AXIS_LEFT_X:
			if value >= 0.0:
				return trs("INPUT_LEFT_STICK_RIGHT")
			else:
				return trs("INPUT_LEFT_STICK_LEFT")
		JOY_AXIS_LEFT_Y:
			if value >= 0.0:
				return trs("INPUT_LEFT_STICK_DOWN")
			else:
				return trs("INPUT_LEFT_STICK_UP")
		JOY_AXIS_RIGHT_X:
			if value >= 0.0:
				return trs("INPUT_RIGHT_STICK_RIGHT")
			else:
				return trs("INPUT_RIGHT_STICK_LEFT")
		JOY_AXIS_RIGHT_Y:
			if value >= 0.0:
				return trs("INPUT_RIGHT_STICK_DOWN")
			else:
				return trs("INPUT_RIGHT_STICK_UP")
		
		JOY_AXIS_TRIGGER_LEFT:
			match layout_type:
				LastInputDevice.LayoutType.Nintendo:
					return trs("INPUT_NINTENDO_LEFT_TRIGGER")
				LastInputDevice.LayoutType.PlayStation:
					return trs("INPUT_PS_LEFT_TRIGGER")
				_:
					return trs("INPUT_XBOX_LEFT_TRIGGER")
		JOY_AXIS_TRIGGER_RIGHT:
			match layout_type:
				LastInputDevice.LayoutType.Nintendo:
					return trs("INPUT_NINTENDO_RIGHT_TRIGGER")
				LastInputDevice.LayoutType.PlayStation:
					return trs("INPUT_PS_RIGHT_TRIGGER")
				_:
					return trs("INPUT_XBOX_RIGHT_TRIGGER")

		_: 
			var suffix: String = "+" if value > 0 else "-"
			return trs("INPUT_AXIS") % [axis, suffix]

static func mouse_button_name(button: MouseButton) -> String:
	match button:
		MouseButton.MOUSE_BUTTON_LEFT:
			return trs("MOUSE_BUTTON_LEFT")
		MouseButton.MOUSE_BUTTON_RIGHT:
			return trs("MOUSE_BUTTON_RIGHT")
		MouseButton.MOUSE_BUTTON_MIDDLE:
			return trs("MOUSE_BUTTON_MIDDLE")
		MouseButton.MOUSE_BUTTON_WHEEL_DOWN:
			return trs("MOUSE_WHEEL_DOWN")
		MouseButton.MOUSE_BUTTON_WHEEL_LEFT:
			return trs("MOUSE_WHEEL_LEFT")
		MouseButton.MOUSE_BUTTON_WHEEL_RIGHT:
			return trs("MOUSE_WHEEL_RIGHT")
		MouseButton.MOUSE_BUTTON_WHEEL_UP:
			return trs("MOUSE_WHEEL_UP")
		MouseButton.MOUSE_BUTTON_XBUTTON1:
			return trs("MOUSE_XBUTTON1")
		MouseButton.MOUSE_BUTTON_XBUTTON2:
			return trs("MOUSE_XBUTTON2")
	return trs(UNKNOWN)

static func get_touch_name(action: String) -> String:
	match action:
		"left":
			return trs("INPUT_LEFT")
		"right":
			return trs("INPUT_RIGHT")
		"up":
			return trs("INPUT_UP")
		"down":
			return trs("INPUT_DOWN")
		"jump":
			return '"%s"' % trs("CTRL_JUMP")
		"spin":
			return '"%s"' % trs("CTRL_SPIN")
		"dive":
			return '"%s"' % trs("CTRL_DIVE")
		"gp":
			return '"%s"' % trs("CTRL_GP")
		"gpcancel":
			return '"%s"' % trs("CTRL_GP_CANCEL")
		"fludd":
			return '"%s"' % trs("CTRL_USE_FLUDD")
		"nozzles":
			return '"%s"' % trs("CTRL_SWAP_NOZZLES")
		"crouch":
			return trs("INPUT_DOWN")
		"interact":
			return trs("INPUT_UP")
		_:
			return trs(UNKNOWN)

static func get_singular_human_name(event: Dictionary) -> String:
	var string: String = ""
	match(event.input_type):
		KEYBOARD:
			var keycode: int = OS.find_keycode_from_string(event.get("key", ""))
			var human_name: String = get_key_human_name(keycode)
			string += human_name
		
		MOUSE:
			string += mouse_button_name(event.button_index)
		
		JOYPAD_BUTTON:
			string += joypad_button_name(event.button_index, LastInputDevice.last_layout_type)
		
		JOYPAD_MOTION:
			string += joypad_motion_name(event.axis, event.axis_value, LastInputDevice.last_layout_type)
	
	return string


static func get_human_name(event_array: Array) -> String:
	var string: String = ""
	for event: Dictionary in event_array:
		if string != "": string += ", "
		string += get_singular_human_name(event)
		
	return string


static func trs(message: StringName, context: StringName = "") -> String:
	return TranslationServer.translate(message, context)


# yeah, i had to make my own function because godot has no built-in way
# to translate keyboard key names rn. oops!
# ...
# jesus christ-
static func get_key_human_name(keycode: Key) -> String:
	match keycode:
		KEY_ESCAPE:
			return trs("KEY_ESCAPE")
		KEY_TAB:
			return trs("KEY_TAB")
		KEY_BACKTAB:
			return trs("KEY_BACKTAB")
		KEY_BACKSPACE:
			return trs("KEY_BACKSPACE")
		KEY_ENTER:
			return trs("KEY_ENTER")
		KEY_KP_ENTER:
			return trs("KEY_KP_ENTER")
		KEY_INSERT:
			return trs("KEY_INSERT")
		KEY_DELETE:
			return trs("KEY_KEY_DELETE")
		KEY_PAUSE:
			return trs("KEY_PAUSE")
		KEY_PRINT:
			return trs("KEY_PRINT")
		KEY_SYSREQ:
			return trs("KEY_SYSREQ")
		KEY_CLEAR:
			return trs("KEY_CLEAR")
		KEY_HOME:
			return trs("KEY_HOME")
		KEY_END:
			return trs("KEY_END")
		KEY_LEFT:
			return trs("KEY_LEFT")
		KEY_UP:
			return trs("KEY_UP")
		KEY_RIGHT:
			return trs("KEY_RIGHT")
		KEY_DOWN:
			return trs("KEY_DOWN")
		KEY_PAGEUP:
			return trs("KEY_PAGEUP")
		KEY_PAGEDOWN:
			return trs("KEY_PAGEDOWN")
		KEY_SHIFT:
			return trs("KEY_SHIFT")
		KEY_CTRL:
			return trs("KEY_CTRL")
		KEY_META:
			return trs("KEY_META")
		KEY_MASK_CMD_OR_CTRL:
			return trs("KEY_CMD_OR_CTRL")
		KEY_ALT:
			return trs("KEY_ALT")
		KEY_CAPSLOCK:
			return trs("KEY_CAPSLOCK")
		KEY_NUMLOCK:
			return trs("KEY_NUMLOCK")
		KEY_SCROLLLOCK:
			return trs("KEY_SCROLLLOCK")
		KEY_KP_MULTIPLY:
			return trs("KEY_KP_MULTIPLY")
		KEY_KP_DIVIDE:
			return trs("KEY_KP_DIVIDE")
		KEY_KP_SUBTRACT:
			return trs("KEY_KP_SUBTRACT")
		KEY_KP_PERIOD:
			return trs("KEY_KP_PERIOD")
		KEY_KP_ADD:
			return trs("KEY_KP_ADD")
		KEY_KP_0:
			return trs("KEY_KP_0")
		KEY_KP_1:
			return trs("KEY_KP_1")
		KEY_KP_2:
			return trs("KEY_KP_2")
		KEY_KP_3:
			return trs("KEY_KP_3")
		KEY_KP_4:
			return trs("KEY_KP_4")
		KEY_KP_5:
			return trs("KEY_KP_5")
		KEY_KP_6:
			return trs("KEY_KP_6")
		KEY_KP_7:
			return trs("KEY_KP_7")
		KEY_KP_8:
			return trs("KEY_KP_8")
		KEY_KP_9:
			return trs("KEY_KP_9")
		KEY_MENU:
			return trs("KEY_MENU")
		KEY_HYPER:
			return trs("KEY_HYPER")
		KEY_HELP:
			return trs("KEY_HELP")
		KEY_BACK:
			return trs("KEY_BACK")
		KEY_FORWARD:
			return trs("KEY_FORWARD")
		KEY_STOP:
			return trs("KEY_STOP")
		KEY_REFRESH:
			return trs("KEY_REFRESH")
		KEY_VOLUMEDOWN:
			return trs("KEY_VOLUMEDOWN")
		KEY_VOLUMEMUTE:
			return trs("KEY_VOLUMEMUTE")
		KEY_VOLUMEUP:
			return trs("KEY_VOLUMEUP")
		KEY_MEDIAPLAY:
			return trs("KEY_MEDIAPLAY")
		KEY_MEDIASTOP:
			return trs("KEY_MEDIASTOP")
		KEY_MEDIAPREVIOUS:
			return trs("KEY_MEDIAPREVIOUS")
		KEY_MEDIANEXT:
			return trs("KEY_MEDIANEXT")
		KEY_MEDIARECORD:
			return trs("KEY_MEDIARECORD")
		KEY_HOMEPAGE:
			return trs("KEY_HOMEPAGE")
		KEY_FAVORITES:
			return trs("KEY_FAVORITES")
		KEY_SEARCH:
			return trs("KEY_SEARCH")
		KEY_STANDBY:
			return trs("KEY_STANDBY")
		KEY_OPENURL:
			return trs("KEY_OPENURL")
		KEY_LAUNCHMAIL:
			return trs("KEY_LAUNCHMAIL")
		KEY_LAUNCHMEDIA:
			return trs("KEY_LAUNCHMEDIA")
		KEY_LAUNCH0:
			return trs("KEY_LAUNCH0")
		KEY_LAUNCH1:
			return trs("KEY_LAUNCH1")
		KEY_LAUNCH2:
			return trs("KEY_LAUNCH2")
		KEY_LAUNCH3:
			return trs("KEY_LAUNCH3")
		KEY_LAUNCH4:
			return trs("KEY_LAUNCH4")
		KEY_LAUNCH5:
			return trs("KEY_LAUNCH5")
		KEY_LAUNCH6:
			return trs("KEY_LAUNCH6")
		KEY_LAUNCH7:
			return trs("KEY_LAUNCH7")
		KEY_LAUNCH8:
			return trs("KEY_LAUNCH8")
		KEY_LAUNCH9:
			return trs("KEY_LAUNCH9")
		KEY_LAUNCHA:
			return trs("KEY_LAUNCHA")
		KEY_LAUNCHB:
			return trs("KEY_LAUNCHB")
		KEY_LAUNCHC:
			return trs("KEY_LAUNCHC")
		KEY_LAUNCHD:
			return trs("KEY_LAUNCHD")
		KEY_LAUNCHE:
			return trs("KEY_LAUNCHE")
		KEY_LAUNCHF:
			return trs("KEY_LAUNCHF")
		KEY_GLOBE:
			return trs("KEY_GLOBE")
		KEY_KEYBOARD:
			return trs("KEY_KEYBOARD")
		KEY_JIS_EISU:
			return trs("KEY_JIS_EISU")
		KEY_JIS_KANA:
			return trs("KEY_JIS_KANA")
		KEY_UNKNOWN:
			return trs("KEY_UNKNOWN")
		KEY_SPACE:
			return trs("KEY_SPACE")
		KEY_EXCLAM:
			return trs("KEY_EXCLAM")
		KEY_QUOTEDBL:
			return trs("KEY_QUOTEDBL")
		KEY_NUMBERSIGN:
			return trs("KEY_NUMBERSIGN")
		KEY_DOLLAR:
			return trs("KEY_DOLLAR")
		KEY_PERCENT:
			return trs("KEY_PERCENT")
		KEY_AMPERSAND:
			return trs("KEY_AMPERSAND")
		KEY_APOSTROPHE:
			return trs("KEY_APOSTROPHE")
		KEY_PARENLEFT:
			return trs("KEY_PARENLEFT")
		KEY_PARENRIGHT:
			return trs("KEY_PARENRIGHT")
		KEY_ASTERISK:
			return trs("KEY_ASTERISK")
		KEY_PLUS:
			return trs("KEY_PLUS")
		KEY_COMMA:
			return trs("KEY_COMMA")
		KEY_MINUS:
			return trs("KEY_MINUS")
		KEY_PERIOD:
			return trs("KEY_PERIOD")
		KEY_SLASH:
			return trs("KEY_SLASH")
		KEY_COLON:
			return trs("KEY_COLON")
		KEY_SEMICOLON:
			return trs("KEY_SEMICOLON")
		KEY_LESS:
			return trs("KEY_LESS")
		KEY_EQUAL:
			return trs("KEY_EQUAL")
		KEY_GREATER:
			return trs("KEY_GREATER")
		KEY_QUESTION:
			return trs("KEY_QUESTION")
		KEY_AT:
			return trs("KEY_AT")
		KEY_BRACKETLEFT:
			return trs("KEY_BRACKETLEFT")
		KEY_BACKSLASH:
			return trs("KEY_BACKSLASH")
		KEY_BRACKETRIGHT:
			return trs("KEY_BRACKETRIGHT")
		KEY_ASCIICIRCUM:
			return trs("KEY_ASCIICIRCUM")
		KEY_UNDERSCORE:
			return trs("KEY_UNDERSCORE")
		KEY_QUOTELEFT:
			return trs("KEY_QUOTELEFT")
		KEY_BRACELEFT:
			return trs("KEY_BRACELEFT")
		KEY_BAR:
			return trs("KEY_BAR")
		KEY_BRACERIGHT:
			return trs("KEY_BRACERIGHT")
		KEY_ASCIITILDE:
			return trs("KEY_ASCIITILDE")
		KEY_YEN:
			return trs("KEY_YEN")
		KEY_SECTION:
			return trs("KEY_SECTION")
		KEY_NONE:
			return trs("KEY_NONE")
		_:
			return OS.get_keycode_string(keycode)
