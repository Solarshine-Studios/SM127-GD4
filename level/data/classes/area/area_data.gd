class_name AreaData
extends LevelDataResource

var header: AreaHeader
# Array of LayerData
var layers: Array[LayerData]

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

func deserialize(_code: String) -> void:
	pass
