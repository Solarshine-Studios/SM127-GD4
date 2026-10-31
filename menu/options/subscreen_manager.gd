class_name SubscreenManager
extends MarginContainer

const DARKEN_TWEEN_DURATION: float = 0.2

@onready var focus: UIFocus = %Focus
@onready var back_button: ButtonHoverHorizontal = %Back

@onready var tab_buttons: MarginContainer = %TabButtons
@onready var back_sound: AudioStreamPlayer = %BackSound

var tween: Tween
var cur_subscreen: int = -1
var last_focus: Control

signal exit_screen

func _ready() -> void:
	for child: Control in get_children():
		child.hide()

func go_back() -> void:
	back_sound.play()
	if cur_subscreen > -1:
		change_subscreen(-1)
	else:
		exit_screen.emit()

# -1 means closed
func change_subscreen(new_subscreen: int = -1) -> void:
	cur_subscreen = new_subscreen
	
	if new_subscreen > -1:
		last_focus = get_viewport().gui_get_focus_owner()
		
		show()
		
		focus_behavior_recursive = Control.FOCUS_BEHAVIOR_INHERITED
		tab_buttons.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
		
		mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED
		tab_buttons.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
		
		if is_instance_valid(tween):
			tween.kill()
		tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(tab_buttons, "modulate", Color(0.5, 0.5, 0.5), DARKEN_TWEEN_DURATION)
		modulate.a = 0.0
		tween.tween_property(self, "modulate:a", 1.0, DARKEN_TWEEN_DURATION)
		
		var selected_subscreen: Subscreen
		for i: int in range(get_child_count()):
			var subscreen: Subscreen = get_child(i)
			subscreen.visible = (i == new_subscreen)
			if subscreen.visible:
				selected_subscreen = subscreen
		
		if is_instance_valid(selected_subscreen.default_focus) and\
		selected_subscreen.default_focus.get_focus_mode_with_override() != FocusMode.FOCUS_NONE:
			selected_subscreen.default_focus.grab_focus()
		focus.default_focus = selected_subscreen.default_focus
		
	else:
		focus.default_focus = back_button
		
		focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
		tab_buttons.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_INHERITED
		
		mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
		tab_buttons.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED
		
		if is_instance_valid(tween):
			tween.kill()
		tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(tab_buttons, "modulate", Color.WHITE, DARKEN_TWEEN_DURATION)
		tween.tween_property(self, "modulate:a", 0.0, DARKEN_TWEEN_DURATION)
		tween.set_parallel(false)
		tween.tween_callback(hide)
		
		if is_instance_valid(last_focus):
			last_focus.grab_focus()
