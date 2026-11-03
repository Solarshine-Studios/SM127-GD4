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

### Serialization
## TODO: Write this
func serialize() -> String:
	return ""

func deserialize(_code: String) -> void:
	pass
