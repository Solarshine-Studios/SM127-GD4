@abstract
class_name KeyScene
extends Node
## Class for key scenes, such as the Title Screen, Mission Select,
## Game World, or others that the TransitionManager can transition to.


func _ready() -> void:
	# okay, type inference here is kind of annoying. maybe we can disable this if it causes more issues.
	# but i'm leaning more towards keeping it
	(TransitionManager as TransitionManagerClass).current_key_scene = self


## Runs when this [KeyScene] is being transitioned to.
@abstract func _on_transition_to(_handover: Variant) -> void


## Runs when this [KeyScene] is being transitioned from.
@abstract func _on_transition_from() -> void
