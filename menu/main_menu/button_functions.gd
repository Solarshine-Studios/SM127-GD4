extends Control


func temp_test() -> void:
	TransitionManager.transition_scene(
		"res://test.tscn",
		SceneTransition.Type.CIRCLE,
		SceneTransition.Type.INV_CIRCLE
	)


func exit_game() -> void:
	get_tree().quit()


func open_discord() -> void:
	OS.shell_open("https://discord.gg/qgfErCy")
