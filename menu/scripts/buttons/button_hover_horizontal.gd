class_name ButtonHoverHorizontal
extends ButtonSound

@export var lerp_speed: float = 12.0
@export var extend_amount: int = 24
@export var direction: int = 1

var original_x: float
var focused: bool = false
var force_hover: bool = false


func on_focus_entered() -> void: 
	super()
	focused = true


func on_focus_exited() -> void:
	super()
	focused = false


func _ready() -> void:
	super()
	original_x = offset_transform_position.x
	offset_transform_enabled = true


func _process(delta: float) -> void:
	## framerate independent
	var interp_amount: float = 1.0 - exp(-lerp_speed * delta)
	if is_hovered() or focused or force_hover:
		offset_transform_position.x = lerp(offset_transform_position.x, original_x + float(extend_amount * direction), interp_amount)
	else:
		offset_transform_position.x = lerp(offset_transform_position.x, original_x, interp_amount)
