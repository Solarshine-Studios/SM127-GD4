extends Container

const FAST_TEXT: String = "CREDITS_FASTER"
const SLOW_TEXT: String = "CREDITS_SLOWER"

@onready var on_sound: AudioStreamPlayer = %OnSound
@onready var off_sound: AudioStreamPlayer = %OffSound

@onready var credits: Control = get_child(0)
@onready var speed_button: ButtonSound = %Speed
@onready var icon_fast: TextureRect = %IconFast
@onready var icon_slow: TextureRect = %IconSlow

@export var normal_scroll: float = 25
@export var fast_scroll: float = 125

var internal_scroll: float
var scroll_speed: float = normal_scroll
var is_rolling: bool = false

signal done_rolling


func screen_opened() -> void:
	credits.offset_transform_position.y = 0
	internal_scroll = 0
	is_rolling = true


func _process(delta: float) -> void:
	if not is_rolling or not is_visible_in_tree(): return
	
	internal_scroll += delta * scroll_speed
	credits.offset_transform_position.y = -internal_scroll
	if credits.offset_transform_position.y < -credits.size.y:
		is_rolling = false
		done_rolling.emit()


func toggle_speed() -> void:
	var was_fast: bool = (scroll_speed == fast_scroll)
	scroll_speed = normal_scroll if was_fast else fast_scroll
	
	speed_button.text = SLOW_TEXT if not was_fast else FAST_TEXT
	speed_button.click_sound = off_sound if was_fast else on_sound
	
	icon_slow.visible = not was_fast
	icon_fast.visible = was_fast
