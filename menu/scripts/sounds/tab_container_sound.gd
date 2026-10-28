class_name TabContainerSound
extends TabContainer


@onready var hover_sound: AudioStreamPlayer = get_parent().get_node("%HoverSound") 
@onready var click_sound: AudioStreamPlayer = get_parent().get_node("%ClickSound") 


@export var hover_override: String
@export var click_override: String


func _ready() -> void:
	if hover_override != "":
		hover_sound = get_parent().get_node("%" + hover_override)
	if click_override != "":
		click_sound = get_parent().get_node("%" + click_override)
	
	tab_hovered.connect(on_hovered)
	tab_selected.connect(on_pressed)


func on_hovered(_tab: int) -> void:
	hover_sound.play()


func on_pressed(_tab: int) -> void:
	click_sound.play()
