class_name LayerHeader
extends LevelDataResource

enum LockAxis {
	None,
	Vertical,
	Horizontal,
	Both
}

var layer_name: String = "Layer %s"
var layer_uuid: String = ""
# "distance" from the g layer, affects scroll speed
var parallax_distance: float = 0.0
var parallax_offset: Vector2 = Vector2.ZERO
var autoset_tint: bool = true
var layer_tint: Color = Color.WHITE
var layer_opacity: float = 1.0
# saved separately to layer opacity
var layer_visible: bool = true
var lock_axis: LockAxis = LockAxis.None

var order: int = 0
var is_ground: bool = true
var is_origin: bool = false
# empty means always activated unless disabled is set to true
var activated_mission_ids: PackedStringArray = PackedStringArray()
# if set to -1, there is no minimum/maximum amount
var min_shines: int = -1
var max_shines: int = -1
# for a layer to be permanently unloaded, if this is true
# it should be stripped from the final exported level code for LSS
var disabled: bool = false


func _init(
		set_parallax_distance: float = 0.0,
		set_parallax_offset: Vector2 = Vector2.ZERO,
		set_autoset_tint: bool = false,
		set_layer_tint: Color = Color.WHITE,
		set_order: int = 0,
		set_is_ground: bool = true,
		set_layer_name: String = "Layer %s",
		set_is_origin: bool = false,
		set_activated_mission_ids: PackedStringArray = PackedStringArray(),
		set_disabled: bool = false,
		set_opacity: float = 1.0,
		set_lock_axis: LockAxis = LockAxis.None,
		set_min_shines: int = -1,
		set_max_shines: int = -1,
		set_layer_uuid: String = UUIDHelper.v4()
	) -> void:
	parallax_distance = set_parallax_distance
	parallax_offset = set_parallax_offset
	autoset_tint = set_autoset_tint
	layer_tint = set_layer_tint
	order = set_order
	is_ground = set_is_ground
	activated_mission_ids = set_activated_mission_ids
	disabled = set_disabled
	layer_opacity = set_opacity
	layer_name = set_layer_name
	is_origin = set_is_origin
	lock_axis = set_lock_axis
	min_shines = set_min_shines
	max_shines = set_max_shines
	layer_uuid = set_layer_uuid


func is_mission_layer() -> bool:
	return min_shines != -1 or max_shines != -1 or not activated_mission_ids.is_empty()
