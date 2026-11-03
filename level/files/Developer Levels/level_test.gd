extends Node2D

## NOTE: please delete this when the level code system is done!

func _ready() -> void:
	var level_code: String = FileAccess.get_file_as_string("res://level/files/Developer Levels/tutorial_hills.txt")
	var level_data_container := LevelDataContainer.new(level_code, true)
	print_properties(level_data_container)

## recursive function
func print_properties(object: Object) -> void:
	var recursion_queue: Array[Variant]
	var script: Script = object.get_script()
	print_rich("[b]-%s-[/b]" % script.get_global_name())
	for property: Dictionary in script.get_script_property_list():
		if (property.name as String).ends_with(".gd"): continue
		if property.name == "_mutex": continue
		if property.name == "faulty_resource": continue
		
		var variable: Variant = object.get(property.name)
		if variable is Object:
			recursion_queue.append(variable)
			print_rich("[i]%s[/i]: ([i]class[/i])" % property.name)
		else:
			print_rich("[i]%s[/i]: %s" % [property.name, variable])
	
	for variable: Variant in recursion_queue:
		print_properties(variable)
