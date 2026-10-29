class_name Screen
extends Control


signal start_transition
signal screen_opened
signal screen_change(new_screen_name: String)

@export var music_id: int = -1
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	# it's often preset to make previews easier,
	# but the theme should be set by the menu controller
	# to make custom themes quick and easy to code
	theme = null


func transition(new_screen_name: String) -> void:
	if is_instance_valid(get_viewport().gui_get_focus_owner()): 
		get_viewport().gui_get_focus_owner().release_focus()
	
	start_transition.emit()
	
	animation_player.play("transition")
	animation_player.animation_finished.connect(animation_finished.bind(new_screen_name), CONNECT_ONE_SHOT)


func animation_finished(_anim_name: StringName, new_screen_name: String) -> void:
	screen_change.emit(new_screen_name)
