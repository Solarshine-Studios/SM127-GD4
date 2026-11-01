extends KeyScene


## Runs when this [KeyScene] is being transitioned to.
func _on_transition_to(_handover: Variant) -> void:
	# in case the game was paused when we switched scenes
	get_tree().paused = false
	
	# to prevent lag from skipping the animation
	await get_tree().process_frame
	TransitionManager.greenlight_load_in.call_deferred()


## Runs when this [KeyScene] is being transitioned from.
func _on_transition_from() -> void:
	pass
