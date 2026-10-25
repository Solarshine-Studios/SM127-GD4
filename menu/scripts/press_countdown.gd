class_name PressCountdown
extends Node

signal text_changed
signal pressed

enum TextStyle {left, right, replace}

const COUNTDOWN: AudioStream = preload("uid://dq058palx2mwr")
const COUNTDOWN_END: AudioStream = preload("uid://c6txqpvcekkwe")

@onready var button: Button = get_parent()
@onready var initial_text: String = tr(button.text)
var audio_player: AudioStreamPlayer

@export var countdown_style: TextStyle = TextStyle.left
@export var countdown_time: int = 5
var count: float = -1.0

func _ready() -> void:
	button.button_down.connect(button_down)
	button.button_up.connect(button_up)
	
	audio_player = AudioStreamPlayer.new()
	audio_player.volume_db = -15
	add_child(audio_player)

func _physics_process(delta: float) -> void:
	if count < 0.0: return
	
	var last_count: float = count
	count -= delta * 3.0 # made it faster cuz it feels better
	
	if ceili(last_count) != ceili(count) and count > 0:
		audio_player.stream = COUNTDOWN
		audio_player.play()
	
	update_text(count)
	if count <= 0.0:
		count = -1.0
		
		pressed.emit()
		button_up()

		audio_player.stream = COUNTDOWN_END
		audio_player.play()

func update_text(number: float) -> void:
	var last_text: String = button.text
	
	var count_text: String = "[" + str(ceili(number)) + "]"
	match countdown_style:
		TextStyle.left:
			button.text = count_text + " " + initial_text
		TextStyle.right:
			button.text = initial_text + " " + count_text
		TextStyle.replace:
			button.text = count_text
	
	if button.text != last_text:
		text_changed.emit()

func button_down() -> void:
	if Input.is_action_pressed("skip_count"):
		count = 0.01
	else:
		count = float(countdown_time)
		audio_player.stream = COUNTDOWN
		audio_player.play()

func button_up() -> void:
	count = -1.0
	
	button.text = initial_text
	text_changed.emit()
