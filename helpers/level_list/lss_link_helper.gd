class_name LSSLinkHelper


## this stuff links level ids on LSS to
## levels in the player's level list :>

## means u can do stuff like playing levels
## in your level list from the lss page

## can also help keep track of levels that you
## downloaded from online and dont own!!


const BASE_FOLDER: String = "user://level_list"
const LINK_PATH: String = "/level.links"
const FULL_PATH: String = BASE_FOLDER + LINK_PATH

const SECTION_NAME: String = "LSS Level Links"
const SECTION_KEY: String = "level_links"


static func get_link_file() -> ConfigFile:
	var link_file: ConfigFile = ConfigFile.new()
	var error: Error = link_file.load(FULL_PATH)
	if error != OK:
		printerr("Error loading LSS link file! Error code: ", error)
	return link_file


static func is_level_in_link(lss_id: String) -> bool:
	var link_file: ConfigFile = get_link_file()
	var links_dict: Dictionary = link_file.get_value(SECTION_NAME, SECTION_KEY, {})
	return links_dict.has(lss_id)


static func add_level_to_link(lss_id: String, level_path: String) -> void:
	var link_file: ConfigFile = get_link_file()
	var links_dict: Dictionary = link_file.get_value(SECTION_NAME, SECTION_KEY, {})
	
	links_dict[lss_id] = level_path
	
	link_file.set_value(SECTION_NAME, SECTION_KEY, links_dict)
	var _save_error: Error = link_file.save(FULL_PATH)


static func remove_level_from_link(lss_id: String) -> void:
	var link_file: ConfigFile = get_link_file()
	var links_dict: Dictionary = link_file.get_value(SECTION_NAME, SECTION_KEY, {})
	
	links_dict.erase(lss_id)
	
	link_file.set_value(SECTION_NAME, SECTION_KEY, links_dict)
	var _save_error: Error = link_file.save(FULL_PATH)


static func get_path_from_id(lss_id: String) -> String:
	var link_file: ConfigFile = get_link_file()
	var links_dict: Dictionary = link_file.get_value(SECTION_NAME, SECTION_KEY, {})
	return links_dict.get(lss_id, "")


static func get_id_from_path(level_path: String) -> String:
	var link_file: ConfigFile = get_link_file()
	var links_dict: Dictionary = link_file.get_value(SECTION_NAME, SECTION_KEY, {})
	
	var found_key: Variant = links_dict.find_key(level_path)
	if found_key != null:
		return found_key as String
	return ""
