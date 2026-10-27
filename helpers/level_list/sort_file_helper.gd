class_name SortFileHelper


const EMPTY_DICTIONARY: Dictionary = {}
const BASE_FOLDER: String = "user://level_list"
const INTERNAL_SORT: String = "res://level/Developer Levels/sort.tres"
const LEVELS: String = "levels"
const FOLDERS: String = "folders"
const CAMPAIGNS: String = "campaigns"
const VERSION: String = "dev_version"


static func add_to_sort(id: String, working_folder: String, sort_type: String) -> void:
	var sort: Dictionary = load_sort_file(working_folder)
	var arr: Array = sort.get_or_add(sort_type, [])
	arr.push_front(id)
	sort[sort_type] = arr
	save_sort_file(working_folder, sort)


static func remove_from_sort(id: String, working_folder: String, sort_type: String) -> void:
	var sort: Dictionary = load_sort_file(working_folder)
	var arr: Array = sort.get(sort_type, [])
	arr.erase(id)
	save_sort_file(working_folder, sort)


static func load_internal_sort_file() -> Dictionary:
	var res: SortFileContainer = load(INTERNAL_SORT)
	if res == null or not "json" in res:
		return EMPTY_DICTIONARY
	var text: String = res.json
	var json := JSON.new()
	var error: Error = json.parse(text)
	if error != OK:
		printerr(json.get_error_message())
		return EMPTY_DICTIONARY
	return json.data as Dictionary


static func load_sort_file(working_folder: String) -> Dictionary:
	var file_path: String = working_folder + "/sort.json"
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		printerr("File " + file_path + " could not be loaded. Error code: " + str(FileAccess.get_open_error()))
		return EMPTY_DICTIONARY
	
	var text: String = file.get_as_text()
	
	var json := JSON.new()
	var error: Error = json.parse(text)
	if error != OK:
		printerr(json.get_error_message())
		return EMPTY_DICTIONARY
	
	return json.data as Dictionary


static func save_sort_file(working_folder: String, save_dict: Dictionary) -> void:
	var file_path: String = working_folder + "/sort.json"
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		printerr("File " + file_path + " could not be loaded. Error code: " + str(FileAccess.get_open_error()))
		return
	
	file.store_string(JSON.stringify(save_dict))


static func get_start_index(sort: Dictionary, sort_type: String) -> int:
	match sort_type:
		LEVELS:
			return get_category_size(sort, FOLDERS) + get_category_size(sort, CAMPAIGNS)
		FOLDERS:
			return get_category_size(sort, CAMPAIGNS)
	return 0


static func get_start_index_with_back(sort: Dictionary, sort_type: String, working_folder: String) -> int:
	var start_index: int = 0 if working_folder == BASE_FOLDER else 1
	return start_index + get_start_index(sort, sort_type)


static func get_category_size(sort: Dictionary, sort_type: String) -> int:
	return (sort.get(sort_type, []) as Array).size()
