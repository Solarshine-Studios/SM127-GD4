extends Node2D

const INDENT: String = "    "

func _ready() -> void:
	var level_code: String = FileAccess.get_file_as_string("res://level/files/Developer Levels/tutorial_hills.txt")
	var level_container := LevelContainer.new(level_code, true)
	print_rich("[color=yellow]Deserializing![/color]")
	print_properties(level_container, "")
	print_rich("[color=green]Serializing![/color]")
	var new_code: String = level_container.serialize()
	print_matching(level_code, new_code)

## recursive functions
func print_array(array: Array[Variant], indent: String) -> void:
	var recursion_queue: Array[Variant]
	for variable: Variant in array:
		if variable is Object:
			recursion_queue.append(variable)
			print_rich("%s([i]class[/i])" % indent)
		else:
			print_rich("%s%s" % [indent, variable])

	for variable: Variant in recursion_queue:
		print_properties(variable, indent)

func print_properties(object: Object, indent: String) -> void:
	var recursion_queue: Array[Variant]
	var script: Script = object.get_script()
	print_rich("%s[b]-%s-[/b]" % [indent, script.get_global_name()])
	indent += INDENT
	for property: Dictionary in script.get_script_property_list():
		if (property.name as String).ends_with(".gd"): continue
		if property.name == "_mutex": continue
		if property.name == "faulty_resource": continue
		
		var variable: Variant = object.get(property.name)
		if variable is Object:
			recursion_queue.append(variable)
			print_rich("%s[i]%s[/i]: ([i]class[/i])" % [indent, property.name])
		elif variable is Array:
			print_rich("%s%s:" % [indent, property.name])
			print_array(variable, INDENT + indent)
		else:
			print_rich("%s[i]%s[/i]: %s" % [indent, property.name, variable])
	
	for variable: Variant in recursion_queue:
		print_properties(variable, indent)

func print_matching(string_1: String, string_2: String) -> void:
	var max_len: int = min(string_1.length(), string_2.length()) as int
	var output_buffer: String = ""
	var consecutive_diffs: int = 0
	var divergence_start_index: int = -1

	var index: int = 0
	while index < max_len:
		var character_1: String = string_1[index]
		var character_2: String = string_2[index]

		if character_1 == character_2:
			consecutive_diffs = 0
			output_buffer += character_1.replace("[", "[lb]")
			index += 1
		else:
			consecutive_diffs += 1
			if consecutive_diffs > 5:
				divergence_start_index = index - consecutive_diffs + 1
				break
			else:
				var safe_character_1: String = character_1.replace("[", "[lb]")
				output_buffer += "[color=red]" + safe_character_1 + "[/color]"
				index += 1

	print_rich(output_buffer)

	if divergence_start_index != -1:
		print_rich("Original code: [color=red]%s[/color]" % string_1.substr(divergence_start_index, consecutive_diffs))
		print_rich("New code: [color=green]%s[/color]" % string_2.substr(divergence_start_index, consecutive_diffs))
