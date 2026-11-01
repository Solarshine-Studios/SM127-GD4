class_name NumberHelper

## Base64 integer encoding (Custom implementation, optimized for character size)
const ENCODED_CHARACTERS: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"

static func base64_encode_int(number: int) -> String:
	var is_negative: bool = false
	if signi(number) < 0:
		is_negative = true
		number = absi(number)
	
	if number == 0:
		return ENCODED_CHARACTERS[0]
	var digits: Array[int] = []
	while number:
		digits.append(int(number % 64))
		number = floori(float(number) / 64)

	var string: String = ""
	if is_negative:
		string = "~"
	for digit in digits:
		string += ENCODED_CHARACTERS[digit]
	return string

static func base64_encode_float(number: float) -> String:
	var is_negative: bool = false
	if signf(number) < 0:
		is_negative = true
		number = absf(number)
	
	var number_components: PackedInt64Array
	var string_components: PackedStringArray = str(number).split(".")
	
	number_components.append(int(string_components[0]))
	if string_components.size() == 2:
		number_components.append(int(string_components[1].insert(0, "1")))

	var string: String = ""
	if is_negative:
		string = "~"
	
	if number_components.size() == 1:
		string += base64_encode_int(number_components[0])
	else:
		string += base64_encode_int(number_components[0])
		string += "."
		string += base64_encode_int(number_components[1])
	
	return string

## Decoding of the above. Both functions return null if invalid, 
## and int/float, respectively, otherwise.
static func base64_decode_int(number: String) -> Variant:
	number = number.strip_edges()
	number = number.strip_escapes()
	if number == "":
		return 0
	
	var is_negative: bool = false
	if number[0] == "~":
		is_negative = true
		number = number.substr(1)
	
	var digits: Array[int] = []
	var index: int = 0
	for digit: String in number:
		var digit_int: int = ENCODED_CHARACTERS.find(digit)
		if digit_int == -1: return null
		digit_int = int(float(digit_int) * pow(64, index))
		digits.append(digit_int)
		index += 1
		
	var final_number: int = 0
	for digit in digits:
		final_number += digit
	
	if is_negative:
		final_number = -final_number
	
	
	return final_number

static func base64_decode_float(number: String) -> Variant:
	var is_negative: bool = false
	if number[0] == "~":
		is_negative = true
		number = number.substr(1)
	
	var components: PackedStringArray = number.split(".")
	var whole: int = 0
	var fract: int = 0
	if components.size() == 1:
		whole = base64_decode_int(components[0])
		if whole == null: return null
	else:
		whole = base64_decode_int(components[0])
		fract = base64_decode_int(components[1])
		if whole == null or fract == null: return null
	
	var fract_string: String = "0." + str(fract).substr(1)

	if not is_negative:
		return float(whole) + fract_string.to_float()
	else:
		return -(float(whole) + fract_string.to_float())
