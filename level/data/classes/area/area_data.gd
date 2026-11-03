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
	return ""

func deserialize(_code_version: int, _code: String) -> void:
	pass
