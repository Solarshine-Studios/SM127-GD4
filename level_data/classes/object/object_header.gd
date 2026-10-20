class_name ObjectHeader
extends LevelDataResource

var type_id: int = 0
var palette: int = 0
var position: Vector2 = Vector2.ZERO
var internal_id: String = ""

func _init(set_position: Vector2 = Vector2.ZERO, set_type_id: int = 1, set_palette: int = 0, set_internal_id: String = "") -> void:
	type_id = set_type_id
	palette = set_palette
	position = set_position
	internal_id = set_internal_id
