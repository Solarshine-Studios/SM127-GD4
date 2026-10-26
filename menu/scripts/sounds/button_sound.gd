class_name ButtonSound
extends Button


@onready var hover_sound: AudioStreamPlayer = owner.get_node("%HoverSound")
@onready var click_sound: AudioStreamPlayer = owner.get_node("%ClickSound")
@onready var original_modulate: Color = modulate
@onready var initial_focus_mode: Control.FocusMode = focus_mode

@export var hover_override: String = ""
@export var click_override: String = ""

@export var highlight_on_focus: bool = true
@export var leading_spaces: int = 0
@export var trailing_spaces: int = 0


## this should REALLY be built-in...
func _input(event: InputEvent) -> void:
	if event is InputEventMouse or event is InputEventMouseButton or event is InputEventMouseMotion:
		focus_mode = Control.FOCUS_NONE
	elif event is InputEventKey or event is InputEventJoypadButton or event is InputEventJoypadMotion:
		focus_mode = initial_focus_mode


func _ready() -> void:
	if hover_override != "":
		hover_sound = get_parent().get_node("%" + hover_override)
	if click_override != "":
		click_sound = get_parent().get_node("%" + click_override)
	
	focus_entered.connect(on_focus_entered)
	focus_exited.connect(on_focus_exited)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	pressed.connect(on_pressed)

	if leading_spaces != 0:
		auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED
		text = tr(text.strip_edges(true, false))
		for i in range(leading_spaces):
			text = " " + text

	if trailing_spaces != 0:
		auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED
		text = tr(text.strip_edges(false, true))
		for i in range(trailing_spaces):
			text += " "


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
