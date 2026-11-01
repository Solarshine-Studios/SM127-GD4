class_name ObjectData
extends LevelDataResource

const PALETTE_PROP_ID: int = -2
const POSITION_PROP_ID: int = -1

var header: ObjectHeader
var properties: Dictionary[int, Variant] = {}
## Properties listed here are to have their actual strings stored in
## TranslationData, and the corresponding property replaced with a key for it.
var translatable_properties: PackedInt64Array = []

### Data operations
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

### Serialization
func serialize() -> String:
	var final_code: String = header.serialize()
	var properties_code: String = ""
	for property_id: int in properties.keys():
		properties_code += DataHelper.serialize_data(property_id)
		properties_code += ":"
		properties_code += DataHelper.serialize_data(properties.get(property_id, null))
		properties_code += ";"
	
	if not properties.is_empty():
		properties_code.erase(properties_code.length() - 1, 1)
		final_code += SerializationHelper.wrap_code_in_brackets(properties_code)
	
	return final_code

func deserialize(_data: String) -> void:
	pass
	## TODO: Implement this
	## (note: i'm removing LevelCodeTokenizer in favor of pure reversable
	## functions for the sake of easier to write/understand code)
	#var object_metadata_code = LevelCodeTokenizer.splice_metadata(object_code)
	#var object_var_code = LevelCodeTokenizer.splice_object(object_code)
	#
	#var object_metadata = deserialize_object_metadata_code(object_metadata_code)
	#var object_data = ObjectData.new(object_metadata)
	#if not object_var_code.empty():
		#var object_vars = deserialize_object_properties(object_var_code)
		#for vars in object_vars:
			#if object_vars[vars] == null:
				#object_vars.erase(vars)
				#object_data.mark_as_faulty("Invalid property in object")
		#object_data.properties = object_vars
	#return object_data
