class_name ButtonSound
extends Button


@onready var hover_sound: AudioStreamPlayer = get_parent().get_node("%HoverSound")
@onready var click_sound: AudioStreamPlayer = get_parent().get_node("%ClickSound")
@onready var original_modulate: Color = modulate

@export var hover_override: String = ""
@export var click_override: String = ""

@export var highlight_on_focus: bool = true


## this should REALLY be built-in...
func _input(event: InputEvent) -> void:
	if event is InputEventMouse or event is InputEventMouseButton or event is InputEventMouseMotion:
		if focus_mode != Control.FOCUS_NONE:
			focus_mode = Control.FOCUS_NONE
	elif event is InputEventKey or event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if focus_mode != Control.FOCUS_ALL:
			focus_mode = Control.FOCUS_ALL


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
