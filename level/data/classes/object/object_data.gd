class_name ObjectData
extends LevelDataResource


const PALETTE_PROP_ID: int = -2
const POSITION_PROP_ID: int = -1


var header: ObjectHeader

## dictionary of int and Variant
var properties: Dictionary[int, Variant] = {}


func _init(set_header: ObjectHeader, set_properties: Dictionary[int, Variant] = {}) -> void:
	header = set_header
	properties = set_properties


func set_property(property_id: int, value: Variant) -> void:
	match property_id:
		PALETTE_PROP_ID:
			if value is int:
				header.palette = value
		POSITION_PROP_ID:
			if value is Vector2:
				header.position = value
		_:
			if properties.has(property_id):
				properties[property_id] = value
			else:
				properties.get_or_add(property_id, value)


func get_property(property_id: int) -> Variant:
	match property_id:
		PALETTE_PROP_ID:
			return header.palette
		POSITION_PROP_ID:
			return header.position
		_:
			return properties.get(property_id)
