class_name AssetData
extends LevelDataResource

## A centralized list of all custom music
## and images used within a level, rather than
## being tied to specific properties like in GD3

var custom_songs: Array[SongData]
var custom_images: Array[ImageData]

### Serialization
## TODO: Write this
func serialize() -> String:
	return ""

func deserialize(_code: String) -> void:
	pass
