extends Node

@onready var pause_controller: PauseController = owner.owner

func resume() -> void:
	pause_controller.pause()

func retry() -> void:
	pass

func retry_start() -> void:
	#CurrentLevelData.checkpoint_data.reset()
	retry()

func quit() -> void:
	# temporary
	# this should probably call a "quit level" function later
	TransitionManager.transition_scene(
		"res://menu/menu_controller/menu_controller.tscn",
		SceneTransition.Type.INV_CIRCLE,
		SceneTransition.Type.CIRCLE
	)
