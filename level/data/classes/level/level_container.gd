class_name LevelContainer
extends LevelDataResource

### From now on, we'll use this class to load level data from its code.

var deserialize_full: bool
var code_version: int
var level_header: LevelHeader
var editor_data: EditorData
var area_data: Array[AreaData]

func _init(code: String, _deserialize_full: bool) -> void:
	# the detected code version gets overwritten 
	# when the level header is read :P
	deserialize_full = _deserialize_full
	deserialize(-1, code)

### Serialization
## TODO: Write this
func serialize() -> String:
	return ""

## Will skip loading header if it is not null 
func deserialize(_code_version: int, code: String) -> void:
	var working_code: String = SerializationHelper.get_outermost_brackets(code)[0]
	level_header = LevelHeader.new(_code_version, SerializationHelper.get_header(working_code))
	code_version = level_header.code_version
	
	if deserialize_full:
		var split_code: PackedStringArray = SerializationHelper.get_outermost_brackets(working_code)
		var area_codes: PackedStringArray = SerializationHelper.get_outermost_brackets(split_code[0])
		for area_code: String in area_codes:
			area_data.append(AreaData.new(code_version, area_code, true))
		editor_data = EditorData.new(code_version, split_code[1])
