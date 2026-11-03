class_name AreaData
extends LevelDataResource

var deserialize_full: bool
var header: AreaHeader
var layers: Array[LayerData]

func _init(code_version: int, code: String, _deserialize_full: bool) -> void:
	deserialize_full = _deserialize_full
	deserialize(code_version, code)

func get_objects_on_ground() -> Array:
	var objects: Array = []
	
	for layer: LayerData in layers:
		if layer.layer_header.is_ground:
			objects.append_array(layer.object_data)
	
	return objects

### Serialization
## TODO: Write this
func serialize() -> String:
	var header_code: String = header.serialize()
	return SerializationHelper.wrap_code_in_brackets(header_code)

func deserialize(code_version: int, code: String) -> void:
	header = AreaHeader.new(code_version, SerializationHelper.get_header(code))
	header.area_code = code
