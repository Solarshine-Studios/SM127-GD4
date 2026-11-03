extends Node2D

## NOTE: please delete this when the level code system is done!

const INDENT: String = "    "

func _ready() -> void:
	var level_code: String = FileAccess.get_file_as_string("res://level/files/Developer Levels/tutorial_hills.txt")
	var level_container := LevelContainer.new(level_code, true)
	print_properties(level_container, "")

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
