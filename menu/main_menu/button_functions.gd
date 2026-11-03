extends Control


func temp_test() -> void:
	TransitionManager.transition_scene(
		"res://global/tests/character_test.tscn",
		SceneTransition.Type.INV_CIRCLE,
		SceneTransition.Type.CIRCLE
	)


func exit_game() -> void:
	get_tree().quit()


func open_discord() -> void:
	OS.shell_open("https://discord.gg/qgfErCy")
