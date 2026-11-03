class_name ObjectHeader
extends LevelDataResource

var type_id: int = 0
var palette: int = 0
var position: Vector2 = Vector2.ZERO
var internal_id: String = ""

### Serialization
func serialize() -> String:
	return SerializationHelper.wrap_code_in_braces(DataHelper.serialize_data_array([
		type_id,
		palette,
		position,
		internal_id
	]))

func deserialize(_code_version: int, code: String) -> void:
	var header: Array[Variant] = DataHelper.deserialize_data_array(code)
	type_id = header[0]
	palette = header[1]
	position = header[2]
	internal_id = header[3]
