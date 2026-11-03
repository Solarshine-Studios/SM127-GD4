class_name LevelDataContainer
extends LevelDataResource

### From now on, we'll use this class to load level data from its code.

var code_version: int
var level_header: LevelHeader
var editor_data: EditorData
var area_headers: Array[AreaHeader]

func _init(code: String, deserialize_full: bool) -> void:
	if code == "":
		return
	
	# the detected code version gets overwritten 
	# when the level header is read :P
	if deserialize_full:
		deserialize(-1, code)
	else:
		deserialize_header(-1, code)

### Serialization
## TODO: Write this
func serialize() -> String:
	return ""

## Will skip loading header if it is not null 
func deserialize(_code_version: int, code: String) -> void:
	if not is_instance_valid(level_header):
		deserialize_header(_code_version, code)
	
	editor_data = EditorData.new(code_version, code)
	# TODO: make this read the actual area codes...
	var area_codes: PackedStringArray
	for area_code: String in area_codes:
		area_headers.append(AreaHeader.new(code_version, area_code))

func deserialize_header(_code_version: int, code: String) -> void:
	level_header = LevelHeader.new(_code_version, code)
	code_version = level_header.code_version
