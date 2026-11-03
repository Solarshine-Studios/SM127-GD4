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
	return SerializationHelper.wrap_code_in_braces(DataHelper.serialize_data_array([
		bounds,
		area_name,
		sky,
		background,
		background_palette,
		bg_autoscroll_speed,
		gravity,
		timer,
		"",
		"",
		shine_shard_count,
		max_purples_count,
		show_name,
		show_song,
		minimum_timer,
		tile_with_edges,
		# NOTE: uncomment this once done testing code matching
		#sky_palette
	]))

func deserialize(code_version: int, code: String) -> void:
	area_code = code
	
	var values: Array[Variant] = DataHelper.deserialize_data_array(code)
	bounds = values[0]
	area_name = values[1]
	sky = values[2]
	background = values[3]
	background_palette = values[4]
	bg_autoscroll_speed = values[5]
	gravity = values[6]
	timer = values[7]
	music = values[8]
	shine_shard_count = values[10]
	max_purples_count = values[11]
	show_name = values[12]
	show_song = values[15]
	minimum_timer = values[16]
	tile_with_edges = values[17]
	
	if code_version >= 103:
		sky_palette = values[18]
	# NOTE: uncomment this once done testing code matching
	#else:
		# everything altered gravity by a factor of 2 in godot 3 
		# the godot 4 version favors using the value as advertised
		#gravity *= 2
