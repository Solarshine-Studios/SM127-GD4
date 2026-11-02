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

## it may seem weird that these are all initialized to unusable values
## however, that's what default_area.tres is for
func _init(
	set_area_code: String = "", 
	set_bounds := Rect2(), 
	set_area_name: String = "", 
	set_sky: int = 0, 
	set_sky_palette: int = 0,
	set_background: int = 0, 
	set_background_palette: int = 0, 
	set_bg_autoscroll_speed: float = 0.0, 
	set_gravity: float = 0.0, 
	set_timer: float = 0.0, 
	set_music: int = 0,
	set_shine_shard_count: int = 0, 
	set_max_purples_count: int = 0,
	set_show_name: bool = true,
	set_show_song: bool = true,
	set_minimum_timer: float = 15,
	set_tile_with_edges: bool = false
) -> void:
	area_code = set_area_code
	bounds = set_bounds
	area_name = set_area_name
	sky = set_sky
	sky_palette = set_sky_palette
	background = set_background
	background_palette = set_background_palette
	bg_autoscroll_speed = set_bg_autoscroll_speed
	gravity = set_gravity
	timer = set_timer
	music = set_music
	shine_shard_count = set_shine_shard_count
	max_purples_count = set_max_purples_count
	show_name = set_show_name
	show_song = set_show_song
	minimum_timer = set_minimum_timer
	tile_with_edges = set_tile_with_edges
