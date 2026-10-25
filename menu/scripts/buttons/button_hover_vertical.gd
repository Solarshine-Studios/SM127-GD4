class_name ButtonHoverVertical
extends ButtonSound

@export var lerp_speed: float = 18.0
@export var extend_amount: int = 4

var original_y: float
var focused: bool = false


func on_focus_entered() -> void: 
	super()
	focused = true


func on_focus_exited() -> void:
	super()
	focused = false


func _ready() -> void:
	super()
	original_y = offset_transform_position.y
	offset_transform_enabled = true


func _process(delta: float) -> void:
	## framerate independent
	var interp_amount: float = 1.0 - exp(-lerp_speed * delta)
	if is_hovered() or focused:
		offset_transform_position.y = lerp(offset_transform_position.y, original_y - extend_amount, interp_amount)
	else:
		offset_transform_position.y = lerp(offset_transform_position.y, original_y, interp_amount)
