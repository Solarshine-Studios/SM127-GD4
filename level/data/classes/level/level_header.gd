class_name LevelHeader
extends LevelDataResource

var level_name: String
var level_author: String
var level_description: String
var level_thumbnail_url: String
var level_thumbnail_sky: int
var level_thumbnail_sky_palette: int
var level_thumbnail_background: int
var level_thumbnail_background_palette: int
var level_version: int = 0

var collectible_data: CollectibleData
var translation_data: TranslationData
var asset_data: AssetData

func _init(
	set_level_name: String = "", 
	set_author: String = "", 
	set_description: String = "", 
	set_url: String = "", 
	set_sky: int = 0,
	set_sky_palette: int = 0, 
	set_background: int = 0, 
	set_background_palette: int = 0, 
	set_level_version: int = 100, 
	set_collectible_data: CollectibleData = null,
	set_translation_data: TranslationData = null,
	set_asset_data: AssetData = null
) -> void:
	level_name = set_level_name
	level_author = set_author
	level_description = set_description
	level_thumbnail_url = set_url
	level_thumbnail_sky = set_sky
	level_thumbnail_sky_palette = set_sky_palette
	level_thumbnail_background = set_background
	level_thumbnail_background_palette = set_background_palette
	level_version = set_level_version
	
	if set_collectible_data != null:
		collectible_data = set_collectible_data
	else:
		collectible_data = CollectibleData.new()
	
	if set_translation_data != null:
		translation_data = set_translation_data
	else:
		translation_data = TranslationData.new()
	
	if set_asset_data != null:
		asset_data = set_asset_data
	else:
		asset_data = AssetData.new()
