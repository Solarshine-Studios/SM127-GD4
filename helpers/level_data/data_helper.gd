class_name DataHelper
## Class that works with primitive data types.
## See SerializationHelper for level code structuring.

## Prefixes used to identify the type of serialized data.
const TYPE_CODE_STRING: String = "S" # String
const TYPE_CODE_INT: String = "I" # int
const TYPE_CODE_BOOL: String = "B" # bool
const TYPE_CODE_FLOAT: String = "F" # float
const TYPE_CODE_VECTOR2: String = "V" # Vector2
const TYPE_CODE_COLOR: String = "C" # Color
const TYPE_CODE_ARRAY: String = "A" # Array
const TYPE_CODE_DICTIONARY: String = "K" # Dictionary
const TYPE_CODE_STRING_ARRAY: String = "aS" # PackedStringArray
const TYPE_CODE_INT_ARRAY: String = "aI" # PackedInt64Array
const TYPE_CODE_FLOAT_ARRAY: String = "aF" # PackedFloat64Array
const TYPE_CODE_VECTOR2_ARRAY: String = "aV" # PackedVector2Array
const TYPE_CODE_BYTES: String = "Y" # PackedByteArray; (lacks the 'a' prefix due to not having a non-array equivalent)
const TYPE_CODE_RECT2: String = "R" # Rect2
const TYPE_CODE_CURVE_2D: String = "U" # Curve2D
const TYPE_CODE_TILE_DATA: String = "T" # TileContainer (wrapper for a PackedByteArray)

## Helper functions that can convert basic data types to and from strings.
static func serialize_data(initial_value: Variant) -> String:
	var code: String = ""
	
	match typeof(initial_value):
		TYPE_STRING:
			var value: String = initial_value
			code = TYPE_CODE_STRING
			if not value.is_empty():
				code += value.uri_encode()
		TYPE_INT:
			var value: int = initial_value
			code = TYPE_CODE_INT + NumberHelper.base64_encode_int(value)
		TYPE_BOOL:
			var value: bool = initial_value
			code = TYPE_CODE_BOOL + str(int(value))
		TYPE_FLOAT:
			var value: float = initial_value
			code = TYPE_CODE_FLOAT + NumberHelper.base64_encode_float(value)
		TYPE_VECTOR2:
			var value: Vector2 = initial_value
			code = TYPE_CODE_VECTOR2 + serialize_data_array([value.x, value.y])
		TYPE_COLOR:
			var value: Color = initial_value
			code = TYPE_CODE_COLOR + serialize_data_array([value.r, value.g, value.b, value.a])
		TYPE_ARRAY:
			var value: Array = initial_value
			code = TYPE_CODE_ARRAY + serialize_data_array(value)
		TYPE_DICTIONARY:
			var value: Dictionary = initial_value
			code = TYPE_CODE_DICTIONARY + serialize_dictionary(value)
		TYPE_PACKED_STRING_ARRAY:
			var value: PackedStringArray = initial_value
			code = TYPE_CODE_STRING_ARRAY + serialize_data_array(value)
		TYPE_PACKED_INT64_ARRAY:
			var value: PackedInt64Array = initial_value
			code = TYPE_CODE_INT_ARRAY + serialize_data_array(value)
		TYPE_PACKED_FLOAT64_ARRAY:
			var value: PackedFloat64Array = initial_value
			code = TYPE_CODE_FLOAT_ARRAY + serialize_data_array(value)
		TYPE_PACKED_VECTOR2_ARRAY:
			var value: PackedVector2Array = initial_value
			code = TYPE_CODE_VECTOR2_ARRAY + serialize_data_array(value)
		TYPE_PACKED_BYTE_ARRAY:
			var value: PackedByteArray = initial_value
			code = TYPE_CODE_BYTES
			if not value.is_empty():
				code += Marshalls.raw_to_base64(value)
				# convert from Base64 to Base64URL
				code = code.replace("+", "-")
				code = code.replace("/", "_")
				# padding in Base64 isn't URI encoding safe, so we replace "="
				# with "~" while serializing
				code = code.replace("=", "~")
		TYPE_RECT2:
			var value: Rect2 = initial_value
			code = TYPE_CODE_RECT2 + serialize_data_array([value.position.x, value.position.y, value.size.x, value.size.y])
		# Any type based on Object is encoded here
		TYPE_OBJECT:
			if initial_value is Curve2D:
				var value: Curve2D = initial_value
				code = TYPE_CODE_CURVE_2D
				
				var point_data := PackedVector2Array()
				for i: int in range(value.get_point_count()):
					point_data.append(value.get_point_position(i))
					point_data.append(value.get_point_in(i))
					point_data.append(value.get_point_out(i))
				
				code += serialize_data(point_data)
			elif initial_value is TileContainer:
				var value: TileContainer = initial_value
				code = TYPE_CODE_TILE_DATA
				
				var tile_byte_data: PackedByteArray = TileHelper.chunks_to_tile_bytes(value.chunks)
				code += serialize_data_array([tile_byte_data])
	
	return code

static func deserialize_data(code: String) -> Variant:
	var type_code: String = code.substr(0, 1)
	var data: String = ""
	if type_code == "a":
		if code.length() < 3: return null
		type_code = code.substr(0, 2)
		data = code.substr(2)
	else:
		data = code.substr(1)
	
	match type_code:
		TYPE_CODE_STRING:
			return data.uri_decode()
		TYPE_CODE_INT:
			return NumberHelper.base64_decode_int(data)
		TYPE_CODE_BOOL:
			return int(data) != 0
		TYPE_CODE_FLOAT:
			return NumberHelper.base64_decode_float(data)
		TYPE_CODE_VECTOR2:
			var data_array: Array[Variant] = deserialize_data_array(data)
			if null in data_array:
				return null
			return Vector2(data_array[0], data_array[1])
		TYPE_CODE_COLOR:
			var data_array: Array[Variant] = deserialize_data_array(data)
			if null in data_array:
				return null
			if(data_array.size() > 3):
				return Color(data_array[0], data_array[1], data_array[2], data_array[3])
			else:
				return Color(data_array[0], data_array[1], data_array[2], 1)
		TYPE_CODE_ARRAY:
			return deserialize_data_array(data)
		TYPE_CODE_DICTIONARY:
			var dictionary: Dictionary = deserialize_dictionary(data)
			if null in dictionary.keys or null in dictionary.values: return null
			return dictionary
		TYPE_CODE_STRING_ARRAY:
			var data_array: Array[Variant] = deserialize_data_array(data)
			if null in data_array:
				return null
			return PackedStringArray(data_array)
		TYPE_CODE_INT_ARRAY:
			var data_array: Array[Variant] = deserialize_data_array(data)
			if null in data_array:
				return null
			return PackedInt64Array(data_array)
		TYPE_CODE_FLOAT_ARRAY:
			var data_array: Array[Variant] = deserialize_data_array(data)
			if null in data_array:
				return null
			return PackedFloat64Array(data_array)
		TYPE_CODE_VECTOR2_ARRAY:
			var data_array: Array[Variant] = deserialize_data_array(data)
			if null in data_array:
				return null
			return PackedVector2Array(data_array)
		TYPE_CODE_BYTES:
			if data.is_empty():
				return PackedByteArray()
			
			# convert from Base64URL to Base64
			data = data.replace("-", "+")
			data = data.replace("_", "/")
			# undo the padding replacement
			data = data.replace("~", "=")
			return Marshalls.base64_to_raw(data)
		TYPE_CODE_RECT2:
			var data_array: Array[Variant] = deserialize_data_array(data)
			if null in data_array:
				return null
			return Rect2(data_array[0], data_array[1], data_array[2], data_array[3])
		TYPE_CODE_CURVE_2D:
			var data_array: Array[Variant] = deserialize_data_array(data)
			if null in data_array:
				return null
			var point_data := PackedVector2Array(data_array)
			
			var curve: Curve2D = Curve2D.new()
			for i in range(0, point_data.size(), 3):
				curve.add_point(point_data[i], point_data[i + 1], point_data[i + 2])
			
			return curve
		# TileData
		TYPE_CODE_TILE_DATA:
			var data_array: Array[Variant] = deserialize_data_array(data)
			if null in data_array:
				return null
				
			var tile_bytes: PackedByteArray = data_array[0]
			var tile_container := TileContainer.new()
			
			var chunk_data: Dictionary = TileHelper.tile_bytes_to_chunks(tile_bytes)
			for chunk_coords: Vector2i in chunk_data.keys():
				tile_container.set_chunk_data(chunk_coords, chunk_data.get(chunk_coords))
			
			return tile_container
	
	printerr("Could not decode data string \"%s\"!")
	return null

## Recursive function that feeds back into serialize_data()
static func serialize_data_array(values: Array[Variant]) -> String:
	var data_array_code: String = ""
	
	for value: Variant in values:
		data_array_code += serialize_data(value)
		data_array_code += ","
	
	if not values.is_empty():
		data_array_code.erase(data_array_code.length() - 1, 1)
	return SerializationHelper.wrap_code_in_brackets(data_array_code)

static func deserialize_data_array(code: String) -> Array[Variant]:
	var variables: Array[Variant] = []
	for variable: Variant in code.split(","):
		variables.push_back(DataHelper.deserialize_data(variable))
	if null in variables: return [null]
	return variables

## Ditto
static func serialize_dictionary(dict: Dictionary) -> String:
	var code: String = ""
	
	for key: Variant in dict.keys():
		var pair_code: String = ""
		pair_code += serialize_data(key)
		pair_code += ":"
		pair_code += serialize_data(dict[key])
		
		code += SerializationHelper.wrap_code_in_brackets(pair_code) + ","
	
	if not code.is_empty():
		code.erase(code.length() - 1, 1)
	return SerializationHelper.wrap_code_in_brackets(code)

static func deserialize_dictionary(code: String) -> Dictionary:
	var pair_codes: PackedStringArray = SerializationHelper.get_outermost_brackets(code)
	var dictionary: Dictionary = {}
	for pair_code: String in pair_codes:
		# this might cause bugs with dictionaries inside dictionaries.
		# not sure whether we've had to grapple with this before though...
		# i think this is how the gd3 code worked so i will leave it for now.
		var pair: PackedStringArray = pair_code.split(":")
		if(pair.size() < 2):
			dictionary.get_or_add("ERROR", null)
		else:
			var key: Variant = deserialize_data(pair[0])
			var value: Variant = deserialize_data(pair[1])
			dictionary.get_or_add(key, value)
	
	return dictionary
