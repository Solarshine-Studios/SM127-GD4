class_name MissionData
extends LevelDataResource


var mission_uuid: String
var mission_show_in_menu: bool

var shine_name: String
var shine_description: String
var shine_sort_order: int
var shine_color: Color
var shine_force_leave: bool

var spawn_area_id: int
var spawn_teleporter_tag: String

# the old internal id the game used to identify shine sprites within levels
# used only for old converted levels
var legacy_id: int = -1


func _init(
		set_mission_uuid: String = "",
		set_mission_show_in_menu: bool = true,
		set_shine_name: String = "Unnamed Shine", 
		set_shine_description: String = "", 
		set_shine_sort_order: int = 0,
		set_shine_color: Color = Color.YELLOW,
		set_shine_force_leave: bool = true,
		set_spawn_area_id: int = 0,
		set_spawn_teleporter_tag: String = "_entrance",
		set_legacy_id: int = -1
	) -> void:
	mission_uuid = set_mission_uuid if not set_mission_uuid.is_empty() else UUIDHelper.v4()
	mission_show_in_menu = set_mission_show_in_menu
	
	shine_name = set_shine_name
	shine_description = set_shine_description
	shine_sort_order = set_shine_sort_order
	shine_color = set_shine_color
	shine_force_leave = set_shine_force_leave
	
	spawn_area_id = set_spawn_area_id
	spawn_teleporter_tag = set_spawn_teleporter_tag
	
	legacy_id = set_legacy_id

static func sort_by_order(a: MissionData, b: MissionData) -> bool:
	return a.shine_sort_order < b.shine_sort_order
