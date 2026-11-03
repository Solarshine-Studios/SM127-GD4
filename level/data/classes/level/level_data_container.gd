class_name LevelDataContainer
extends LevelDataResource

### From now on, we'll use this class to load level data from its codes.

var level_header: LevelHeader
var editor_data: EditorData
var area_headers: Array

func _init(code: String, deserialize_full: bool) -> void:
	if code == "":
		return
	
	if deserialize_full:
		deserialize(code)
	else:
		deserialize_header(code)

### Serialization
## TODO: Write this
func serialize() -> String:
	return ""

## Will skip loading header if it is not null 
func deserialize(code: String) -> void:
	if not is_instance_valid(level_header):
		deserialize_header(code)

func deserialize_header(code: String) -> void:
	level_header = LevelHeader.new(code)
