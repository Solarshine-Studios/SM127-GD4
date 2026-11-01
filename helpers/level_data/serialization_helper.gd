class_name SerializationHelper
## Class that works with level code structuring.
## See DataHelper for data serialization.

static func serialize_header(values: Array[Variant]) -> String:
	return wrap_code_in_braces(DataHelper.serialize_data_array(values))

static func deserialize_header(code: String) -> Array[Variant]:
	return DataHelper.deserialize_data_array(get_outermost_brackets(code)[0])

## Used mainly for headers
static func wrap_code_in_braces(code: String) -> String:
	return "{%s}" % code

## Used en masse throughout level codes
static func wrap_code_in_brackets(code: String) -> String:
	return "[%s]" % code

## Get brackets on the outermost layer, and ignore everything within curly braces
static func get_outermost_brackets(text: String) -> PackedStringArray:
	var results: Array = []
	var depth := 0
	var start := -1
	var in_braces := 0 

	for i in text.length():
		var c := text[i]
		
		# Track curly brace depth
		if c == "{":
			in_braces += 1
		elif c == "}":
			if in_braces > 0:
				in_braces -= 1

		elif in_braces == 0:
			if c == "[":
				if depth == 0:
					start = i + 1  
				depth += 1
			elif c == "]":
				depth -= 1
				if depth == 0 and start != -1:
					results.append(text.substr(start, i - start))  
					start = -1
	
	return results
