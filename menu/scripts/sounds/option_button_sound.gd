class_name OptionButtonSound
extends OptionButton


@onready var hover_sound: AudioStreamPlayer = get_parent().owner.get_node("%HoverSound")
@onready var click_sound: AudioStreamPlayer = get_parent().owner.get_node("%ClickSound")
@onready var select_sound: AudioStreamPlayer = get_parent().owner.get_node("%OnSound")
@onready var original_modulate: Color = modulate
@onready var initial_focus_mode: Control.FocusMode = focus_mode

@export var hover_override: String = ""
@export var click_override: String = ""

@export var highlight_on_focus: bool = true
@export var leading_spaces: int = 0
@export var trailing_spaces: int = 0

var initial_text: String


## this should REALLY be built-in...
func _input(event: InputEvent) -> void:
	if event is InputEventMouse or event is InputEventMouseButton or event is InputEventMouseMotion:
		focus_mode = Control.FOCUS_NONE
	elif event is InputEventKey or event is InputEventJoypadButton or event is InputEventJoypadMotion:
		focus_mode = initial_focus_mode


func _ready() -> void:
	initial_text = text
	
	get_popup().content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	
	if hover_override != "":
		hover_sound = get_parent().get_node("%" + hover_override)
	if click_override != "":
		click_sound = get_parent().get_node("%" + click_override)
	
	item_selected.connect(on_item_pressed)
	item_focused.connect(on_item_focus_entered)
	
	focus_entered.connect(on_focus_entered)
	focus_exited.connect(on_focus_exited)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	pressed.connect(on_pressed)
	
	handle_spaces()


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and initial_text != "":
		handle_spaces()


func handle_spaces() -> void:
	var working_text: String = tr(initial_text.strip_edges())
	var right_to_left: bool = LanguageHelper.is_first_char_rtl(working_text)
	
	if leading_spaces != 0:
		text = working_text
		for i in range(leading_spaces):
			if right_to_left:
				text += " "
			else:
				text = " " + text
		working_text = text

	if trailing_spaces != 0:
		text = working_text
		for i in range(trailing_spaces):
			if right_to_left:
				text = " " + text
			else:
				text += " "
		working_text = text


func on_mouse_entered() -> void:
	if disabled:
		return
	hover_sound.play()


func on_mouse_exited() -> void:
	if disabled:
		return
	release_focus()


func on_focus_entered() -> void:
	if disabled:
		return
	hover_sound.play()
	
	if highlight_on_focus:
		modulate = original_modulate * 1.4
		modulate.a = original_modulate.a


func on_focus_exited() -> void:
	if disabled:
		return
	
	if highlight_on_focus:
		modulate = original_modulate


func on_pressed() -> void:
	click_sound.play()


func on_item_focus_entered(_index: int = -1) -> void:
	if disabled: return
	hover_sound.play()


func on_item_pressed(_index: int = -1) -> void:
	select_sound.play()
