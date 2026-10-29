class_name KeybindButton
extends VBoxContainer

## consts
const UNBOUND_TEXT: String = "CTRL_UNBOUND"

@onready var label: Label = %Action
@onready var button: Button = %Button
@onready var reset_button: Button = %Reset
@onready var remapper: Remapper = %Remapper
@onready var sprite: Control = %Sprite

## binding
@export var option_name: StringName = "CTRL_PLACEHOLDER"
@export var input_group: StringName
@export var input_key: StringName
@export var force_ctrl: bool = false
var is_controller: bool

## visuals 
@export var sprite_visible: bool = true
@export var sprite_animation: String
@export var sprite_rotation: float
@export var sprite_offset: Vector2


func _ready() -> void:
	if not Engine.is_editor_hint():
		if is_instance_valid(remapper):
			button.pressed.connect(remapper.start_listening.bind(self, get_parent()))
			reset_button.pressed.connect(remapper.reset_keybind.bind(self))
		change_button_text()
	update()

func pressed() -> void:
	update()


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and is_instance_valid(button):
		change_button_text()


## button text
func return_default_text() -> String:
	var action_data: Array = InputSettingsHelper.get_setting_partial(input_group, input_key, is_controller)
	if action_data == []:
		return tr(UNBOUND_TEXT)
	
	return InputEventHelper.get_human_name(action_data)

func change_button_text(new_text: String = "") -> void:
	if new_text == "": 
		new_text = return_default_text()
	
	if force_ctrl and new_text != tr(UNBOUND_TEXT) and new_text != remapper.INPUT_WAIT_TEXT and not is_controller:
		button.text = ""
		var keys: PackedStringArray = new_text.split(", ")
		for key_name: String in keys:
			if not button.text.is_empty():
				button.text += ", "
			button.text += tr("KEY_CTRL") + "+" + key_name
	else:
		button.text = new_text


## label and sprite styling
func update() -> void:
	label.text = option_name
	
	## sprite stuff
	sprite.visible = sprite_visible
	if not sprite_visible: 
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		sprite.visible = false
		return
	
	#sprite.play(sprite_animation)
	#sprite.rotation_degrees = sprite_rotation
	#sprite.offset = sprite_offset
