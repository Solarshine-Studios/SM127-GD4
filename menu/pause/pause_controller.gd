extends CanvasLayer

@onready var cooldown: Timer = %Cooldown
@onready var screen_manager: ScreenManager = %Screens
@onready var blur_animation: AnimationPlayer = %BlurAnimation

var is_open: bool

func set_tree_paused(value: bool) -> void:
	get_tree().paused = value

func can_pause() -> bool:
	return not TransitionManager.transitioning

func pause() -> void:
	if not cooldown.is_stopped(): return
	cooldown.start()
	
	if is_open:
		is_open = false
		#screen_manager.current_screen.transition("")
		blur_animation.play("transition")
		
		cooldown.timeout.connect(set_tree_paused.bind(false), CONNECT_ONE_SHOT)
	
	elif can_pause():
		is_open = true
		#screen_manager.screen_change("MainMenu")
		blur_animation.play_backwards("transition")
		set_tree_paused(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause()
