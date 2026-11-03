class_name SerializationHelper
## Class that works with level code structuring.
## See DataHelper for data serialization.

const UPPERCASE_HEX_PATTERN: String = "%([0-9a-fA-F]{2})"
const HEADER_PATTERN: String = "\\{([^{}]*)\\}"
const DATA_PATTERN: String = "(?:[^\\[\\],]+|\\[[^\\]]*\\])+"

# uri_decode() only takes hex values with uppercase lettors now... 
# in godot 3 it used to output them in lowercase. so now we have to do this. oops
static func fix_old_code(code: String) -> String:
	var regex := RegEx.new()
	regex.compile(UPPERCASE_HEX_PATTERN)
	
	var matches: Array[RegExMatch] = regex.search_all(code)
	if matches.is_empty():
		return code
		
	var out: String = ""
	var last_pos: int = 0
	for found_match: RegExMatch in matches:
		var start: int = found_match.get_start()
		out += code.substr(last_pos, start - last_pos)
		out += "%" + found_match.get_string(1).to_upper()
		last_pos = found_match.get_end()
	out += code.substr(last_pos)
	
	return out

## Used mainly for headers
static func wrap_code_in_braces(code: String) -> String:
	return "{%s}" % code

## Used en masse throughout level codes
static func wrap_code_in_brackets(code: String) -> String:
	return "[%s]" % code

## Pass any type into this to get its header.
static func get_header(code: String) -> String:
	var regex := RegEx.new()
	regex.compile(HEADER_PATTERN)
	return regex.search(code).get_string(1)

## Used to get a list of primitive data types
## Will avoid internal commas, unlike string.split()
static func splice_data(code: String) -> PackedStringArray:
	var regex := RegEx.new()
	regex.compile(DATA_PATTERN)
	return regex_match_to_string_array(regex.search_all(code))

static func regex_match_to_string_array(matches: Array) -> Array:
	var result: PackedStringArray = []
	for mat: RegExMatch in matches:
		result.push_back(mat.get_string(0))
	return result

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
