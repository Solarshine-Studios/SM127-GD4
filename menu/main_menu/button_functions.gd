extends Control


func exit_game() -> void:
	get_tree().quit()


func open_discord() -> void:
	OS.shell_open("https://discord.gg/qgfErCy")
