class_name LevelHeader
extends LevelDataResource

const LATEST_CODE_VERSION: int = 103

var level_name: String
var level_author: String
var level_description: String
var thumbnail_url: String
var thumbnail_sky: int
var thumbnail_sky_palette: int
var thumbnail_background: int
var thumbnail_background_palette: int
var code_version: int = 0

var collectible_data: CollectibleData
var translation_data: TranslationData
var asset_data: AssetData

### Serialization
## TODO: Write this
func serialize() -> String:
	code_version = LATEST_CODE_VERSION
	return SerializationHelper.serialize_header([
		level_name,
		level_author,
		level_description,
		thumbnail_url,
		thumbnail_sky,
		thumbnail_background,
		thumbnail_background_palette,
		code_version,
		# NOTE: uncomment this once done testing code matching
		#thumbnail_sky_palette
	])

func deserialize(_code_version: int, code: String) -> void:
	var values: Array[Variant] = SerializationHelper.deserialize_header(code)
	level_name = values[0]
	level_author = values[1]
	level_description = values[2]
	thumbnail_url = values[3]
	thumbnail_sky = values[4]
	thumbnail_background = values[5]
	thumbnail_background_palette = values[6]
	code_version = values[7]
	if code_version >= 103:
		thumbnail_sky_palette = values[8]
