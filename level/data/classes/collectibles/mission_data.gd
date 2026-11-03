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

## the old internal id the game used to identify shine sprites within levels
## used only for old converted levels
var legacy_id: int = -1

static func sort_by_order(a: MissionData, b: MissionData) -> bool:
	return a.shine_sort_order < b.shine_sort_order

### Serialization
## TODO: Write this
func serialize() -> String:
	return ""

func deserialize(_code_version: int, _code: String) -> void:
	pass
