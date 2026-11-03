class_name EditorData
extends LevelDataResource

const MAX_LOADOUTS: int = 4
const DEFAULT_ITEMS: Array[Array] = [
	["til_grass", "til_snow", "til_sand", "til_crystal", "til_lava_rock", "til_brick", "obj_shine", "obj_coin", "obj_wood_platform", "obj_touch_lift"],
	["obj_pine_tree", "obj_big_tree", "obj_flower_bush", "obj_twisted_tree_top", "obj_mushroom_top", "obj_rock", "obj_arrow", "obj_goomba", "obj_koopa_troopa", "obj_bob_omb"],
	["obj_cannon", "obj_launch_star", "obj_sling_star", "obj_propeller", "obj_water", "obj_lava", "obj_note_block", "obj_spike_trap", "obj_sawblade", "obj_fire"],
	["obj_sign", "obj_toad", "obj_red_bob_omb", "obj_yoshi", "obj_dialogue_trigger", "obj_layer_changer", "obj_shine_activator", "obj_zoom_trigger", "obj_area_transition", "obj_death_plane"],
]

var loadouts: Array[Array] = []
var palettes: Array[Array] = []
var fav_items: Array[Array] = []
var fav_counts: Array[int] = []
var selected_loadout: int = 0

var selected_layer: String = ""
var show_palettes: bool = true
var area_boundset_increment: float = 10.0
var camera_positions: Array[Vector2] = [Vector2(288, 840)]
var last_area: int = 0
var pixel_snap: Vector2 = Vector2(8, 8)
var target_tag: String = "_entrance"

### Serialization
## TODO: Write this
func serialize() -> String:
	return ""

func deserialize(_code_version: int, _code: String) -> void:
	pass
