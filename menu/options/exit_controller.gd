extends Node

@export var target_screen: String = "MainMenu"

func exit() -> void:
	var screen: Screen = owner
	screen.transition(target_screen)
