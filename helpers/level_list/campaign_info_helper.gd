class_name CampaignInfoHelper


const DEFAULT_AUTHOR: String = "Unknown"
const DEFAULT_DESCRIPTION: String = "This is a campaign. Add some levels and give it a try!̣\n\nNote that you'll need to set a hub level in Campaign Settings first."
const EMPTY_DICTIONARY: Dictionary = {}


static func load_info_file(working_folder: String) -> Dictionary:
	var file: FileAccess = FileAccess.open(working_folder + "/info.json", FileAccess.READ)
	if file == null:
		var err: Error = FileAccess.get_open_error()
		printerr("File " + working_folder + "/info.json" + " could not be loaded. Error code: " + str(err))
		return EMPTY_DICTIONARY
	
	var json := JSON.new()
	var parse_err: Error = json.parse(file.get_as_text())
	
	if parse_err != OK:
		printerr(json.get_error_message())
		return EMPTY_DICTIONARY
	
	return json.get_data() as Dictionary


static func save_info_file(working_folder: String, save_dict: Dictionary) -> void:
	var file: FileAccess = FileAccess.open(working_folder + "/info.json", FileAccess.WRITE)
	if file == null:
		var err: Error = FileAccess.get_open_error()
		printerr("File " + working_folder + "/info.json" + " could not be loaded. Error code: " + str(err))
		return
	
	file.store_string(JSON.stringify(save_dict))


static func create_info_dict() -> Dictionary:
	var info: Dictionary = {}
	info["author"] = DEFAULT_AUTHOR
	info["description"] = DEFAULT_DESCRIPTION
	info["hub_level"] = ""
	info["intro_level"] = ""
	return info
