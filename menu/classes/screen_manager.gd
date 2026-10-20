class_name ScreenManager
extends Control

signal screen_changed

@export var default_screen: NodePath
@onready var current_screen: Screen


func _ready() -> void:
	current_screen = get_node_or_null(default_screen) as Screen
	## TODO: Uncomment once Music singleton is added
	# if is_instance_valid(current_screen) and current_screen.music_id > -1:
	#	Singleton.Music.change_song(Singleton.Music.last_song, current_screen.music_id)
	
	for screen: Screen in get_children():
		screen.connect("screen_change", screen_change)
		screen.visible = (screen == current_screen)
		if screen.visible:
			# do open animation sped-up so its visible if the
			# reset vars normally make it invisible
			screen.animation_player.play("transition", -1, -INF, true)
			screen.emit_signal("screen_opened")


func screen_change(new_screen_name: String) -> void:
	if is_instance_valid(current_screen):
		current_screen.visible = false
	
	var new_screen: Screen = get_node_or_null(new_screen_name) as Screen
	if not is_instance_valid(new_screen): 
		current_screen = null
		emit_signal("screen_changed")
		return
	
	current_screen = new_screen
	
	new_screen.animation_player.play_backwards("transition")
	new_screen.visible = true
	
	## TODO: Uncomment once Music singleton is added
	#if new_screen.music_id > -1:
	#	Singleton.Music.change_song(Singleton.Music.last_song, new_screen.music_id)
	
	new_screen.emit_signal("screen_opened")
	emit_signal("screen_changed")


func get_screen_name() -> String:
	if not is_instance_valid(current_screen): return "None"
	return current_screen.name
