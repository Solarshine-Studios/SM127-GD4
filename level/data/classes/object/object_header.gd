class_name ObjectHeader
extends LevelDataResource

var type_id: int = 0
var palette: int = 0
var position: Vector2 = Vector2.ZERO
var internal_id: String = ""

### Serialization
func serialize() -> String:
	return SerializationHelper.serialize_header([
		type_id,
		palette,
		position,
		internal_id
	])

func deserialize(_code_version: int, code: String) -> void:
	var header: Array[Variant] = SerializationHelper.deserialize_header(code)
	type_id = header[0]
	palette = header[1]
	position = header[2]
	internal_id = header[3]
