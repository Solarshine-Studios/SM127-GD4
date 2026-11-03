class_name AreaHeader
extends LevelDataResource

var area_name: String
var bounds: Rect2
var tile_with_edges: bool = false
var show_name: bool = true
var show_song: bool = true

var sky: int
var sky_palette: int
var background: int
var background_palette: int
var bg_autoscroll_speed: float

## now holds a pointer to another spot instead of data being stored here
## negative means it's a custom song (grab from AssetData)
## positive means it's a preset song (grab from res://)
var music: int

var gravity: float
var timer: float
var minimum_timer: float = 15
## holds the code for the entire area, so that an area can be loaded with just its header 
var area_code: String

var shine_shard_count: int = 0
var max_purples_count: int = 0

### Serialization
## TODO: Write this
func serialize() -> String:
	return ""

func deserialize(_code_version: int, _code: String) -> void:
	pass
