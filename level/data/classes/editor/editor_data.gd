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

func _init(
		set_loadouts: Array[Array] = [], 
		set_palettes: Array[Array] = [], 
		set_fav_items: Array[Array] = [], 
		set_fav_counts: Array[int] = [], 
		set_selected_loadout: int = 0,
		set_selected_layer: String = "",
		set_show_palettes: bool = true,
		set_area_boundset_increment: float = 10.0,
		set_camera_positions: Array[Vector2] = [Vector2(288, 840)],
		set_last_area: int = 0,
		set_pixel_snap: Vector2 = Vector2(8, 8),
		set_target_tag: String = "_entrance"
	) -> void:
	loadouts = set_loadouts
	palettes = set_palettes
	fav_items = set_fav_items
	fav_counts = set_fav_counts
	selected_loadout = set_selected_loadout
	
	var i: int = loadouts.size() - 1
	var default_index: int = 0
	while i < MAX_LOADOUTS - 1:
		loadouts.append(DEFAULT_ITEMS[default_index])
		i += 1
		default_index += 1
	i = palettes.size() - 1
	while i < MAX_LOADOUTS - 1:
		palettes.append([0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
		i += 1
	i = fav_items.size() - 1
	while i < MAX_LOADOUTS - 1:
		fav_items.append([])
		i += 1
	i = fav_counts.size() - 1
	while i < MAX_LOADOUTS - 1:
		fav_counts.append(0)
		i += 1
	
	selected_layer = set_selected_layer
	show_palettes = set_show_palettes
	area_boundset_increment = set_area_boundset_increment
	camera_positions = set_camera_positions
	last_area = set_last_area
	pixel_snap = set_pixel_snap
	target_tag = set_target_tag
