extends Node


const MOUSE_IDLE_TIME: float = 5.0

var class_type_map: Dictionary[String, int] = {
	"InputEventKey": InputType.Keyboard,
	"InputEventJoypadButton": InputType.Controller,
	"InputEventJoypadMotion": InputType.Controller,
	"InputEventScreenTouch": InputType.Touch,
	"InputEventScreenDrag": InputType.Touch,
	"InputEventGesture": InputType.Touch,
	"InputEventPanGesture": InputType.Touch
}

enum InputType {Keyboard, Controller, Touch}
enum LayoutType {Xbox, Nintendo, PlayStation}

var last_input_type: int = InputType.Keyboard
var last_layout_type: int = LayoutType.Xbox
var is_mouse: bool = false
var do_rumble: bool = false
var last_controller: int = 0

var mouse_idle_timer: Timer

var layouts_regex: Dictionary[int, Array] = {
	LayoutType.Nintendo: [
		"(?i)Wii", "(?i)S?NES", "(?i)Switch", "(?i)Joy[- ]Con"
	],
	LayoutType.PlayStation: [
		".*PS\\d.*", "(?i)Sony.*", "(?i)Play[Ss]tation"
	]
}

signal input_type_changed(new_input_type: int)
signal mouse_changed(is_mouse: bool)

func _input(event: InputEvent) -> void:
	
	if not "device" in event or event.device != -1:
		var last_mouse: bool = is_mouse
		is_mouse = (event is InputEventMouseMotion or event is InputEventMouseButton or event is InputEventScreenTouch or event is InputEventScreenDrag)
		if is_mouse != last_mouse:
			mouse_changed.emit(is_mouse)
	
	if event.device != -1 and (event is InputEventJoypadButton or event is InputEventJoypadMotion): last_controller = event.device
	
	var class_string: String = event.get_class()
	if class_string in class_type_map:
		var new_input_type: int = class_type_map.get(class_string, InputType.Keyboard)
		
		if new_input_type == InputType.Controller:
			var new_layout_type: int = LayoutType.Xbox
			for layout_type: LayoutType in layouts_regex.keys():
				for regex_string: String in layouts_regex[layout_type]:
					var regex := RegEx.new()
					regex.compile(regex_string)
					var result: RegExMatch = regex.search(Input.get_joy_name(event.device))
					if result:
						new_layout_type = layout_type
			last_layout_type = new_layout_type
		
		if new_input_type != last_input_type:
			input_type_changed.emit(new_input_type)
		
		last_input_type = new_input_type

	# show mouse again if it was made hidden
	if is_mouse:
		if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_HIDDEN:
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		mouse_idle_timer.start()

func rumble(weak_power: float, strong_power: float, time: float) -> void:
	if not do_rumble: return
	if not last_input_type == InputType.Controller: return
	Input.stop_joy_vibration(last_controller)
	Input.start_joy_vibration(last_controller, weak_power, strong_power, time)

func stop_rumble() -> void:
	if not do_rumble: return
	if not last_input_type == InputType.Controller: return
	Input.stop_joy_vibration(last_controller)

# for hiding the cursor on inactivity
func _ready() -> void:
	mouse_idle_timer = Timer.new()
	mouse_idle_timer.wait_time = MOUSE_IDLE_TIME
	mouse_idle_timer.one_shot = true
	mouse_idle_timer.timeout.connect(hide_cursor)
	add_child(mouse_idle_timer)
	mouse_idle_timer.start()

func hide_cursor() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
