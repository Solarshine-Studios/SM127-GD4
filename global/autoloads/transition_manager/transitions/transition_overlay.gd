@tool
class_name TransitionOverlay
extends ColorRect
## The base class for all transition overlays.[br][br]
## To be instanced in a scene file along with an [AnimationPlayer].[br]
## For a list of all available transitions, see [SceneTransition].

@onready var default_color: Color = color
@onready var animation: AnimationPlayer = $AnimationPlayer


func play_transition(
		custom_color: Color = default_color,
		speed_scale: float = 1.0,
		play_backwards: bool = false
) -> void:
	assert(
		is_instance_valid(animation),
		"""No AnimationPlayer node was found. TransitionOverlays must contain an 
		AnimationPlayer child with an animation named \"transition\" to function properly!"""
	)

	color = custom_color

	var dir: float = -1 if play_backwards else 1
	animation.play("transition", -1, abs(speed_scale) * dir, play_backwards)
