class_name RangeSound
extends Range


@onready var hover_sound: AudioStreamPlayer = owner.get_node("%HoverSound")
@onready var click_sound: AudioStreamPlayer = owner.get_node("%ClickSound")
@onready var original_modulate: Color = modulate
@onready var initial_focus_mode: Control.FocusMode = focus_mode

@export var hover_override: String = ""
@export var click_override: String = ""

@export var highlight_on_focus: bool = true


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
	value_changed.connect(play_sound)


func on_mouse_entered() -> void:
	hover_sound.play()


func on_mouse_exited() -> void:
	release_focus()


func on_focus_entered() -> void:
	hover_sound.play()
	
	if highlight_on_focus:
		modulate = original_modulate * 1.4
		modulate.a = original_modulate.a


func on_focus_exited() -> void:
	if highlight_on_focus:
		modulate = original_modulate


func play_sound(val: float) -> void:
	click_sound.pitch_scale = map(val, min_value, max_value, 0.5, 2.0)
	click_sound.play()
	await click_sound.finished
	click_sound.pitch_scale = 1.0


static func map(val: float, val_min: float, val_max: float, new_min: float, new_max: float) -> float:
	var clamped_val: float = clamp(val, val_min, val_max)
	return (clamped_val - val_min) * (new_max - new_min) / (val_max - val_min) + new_min
