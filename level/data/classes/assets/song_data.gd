class_name SongData
extends LevelDataResource

## (or file path, if used within a campaign)
var url: String
## not absolute volume, but an offset from the file's volume
## helps avoid constant volume tuning in audacity...
var volume: float

var song_name: String
## let's not re-add the "By" part here it isn't necessary
var song_author: String

var loop_start: float
var loop_end: float

## array of other songs that it can blend with (for i.e. water music)
## negative for custom, positive for preset
## area changers can be used for HMC type music blending
## but it'll also blend with music listed here when switching areas
var blends_with: PackedInt64Array
## if this is true, the first index in blends_with is used while underwater
var has_underwater_variant: bool

### Serialization
## TODO: Write this
func serialize() -> String:
	return ""

func deserialize(_data: String) -> void:
	pass
