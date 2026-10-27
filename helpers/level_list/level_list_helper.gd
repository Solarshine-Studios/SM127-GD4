class_name LevelListHelper


const BASE_FOLDER: String = "user://level_list"
const DEV_FOLDER: String = BASE_FOLDER + "/Developer Levels"
const INTERNAL_DEV_FOLDER: String = "res://level/Developer Levels/"
const ENCRYPTION_PASSWORD: String = "BadCode"


## MISC
static func file_exists(file_path: String) -> bool:
	return FileAccess.file_exists(file_path)

static func dir_exists(dir_path: String) -> bool:
	return DirAccess.dir_exists_absolute(dir_path)

static func delete_file(file_path: String) -> void:
	var err: int = OS.move_to_trash(ProjectSettings.globalize_path(file_path))
	if err != OK:
		printerr("Failure deleting level file. Error code: " + str(err))

static func move_file(file_path: String, new_path: String) -> void:
	var err: int = DirAccess.rename_absolute(file_path, new_path)
	if err != OK:
		printerr("Failure moving file/directory. Error code: " + str(err))

static func generate_level_id() -> String:
	return UUIDHelper.v4()


static func move_level_files(level_id: String, working_folder: String, new_folder: String) -> void:
	if is_campaign(working_folder):
		var info_dict: Dictionary = CampaignInfoHelper.load_info_file(working_folder)
		if info_dict.get("hub_level", "") == level_id:
			info_dict["hub_level"] = ""
		if info_dict.get("intro_level", "") == level_id:
			info_dict["intro_level"] = ""
		CampaignInfoHelper.save_info_file(working_folder, info_dict)
	
	SortFileHelper.remove_from_sort(level_id, working_folder, SortFileHelper.LEVELS)
	SortFileHelper.add_to_sort(level_id, new_folder, SortFileHelper.LEVELS)

	var file_path: String = get_level_file_path(level_id, working_folder)
	var new_file_path: String = get_level_file_path(level_id, new_folder)
	move_file(file_path, new_file_path)
	
	if not is_campaign(working_folder):
		var save_path: String = get_level_save_path(level_id, working_folder, -1)
		var new_save_path: String = get_level_save_path(level_id, new_folder, -1)
		if file_exists(save_path):
			move_file(save_path, new_save_path)
	else:
		for i in range(3):
			var save_path: String = get_level_save_path(level_id, working_folder, -1)
			if file_exists(save_path):
				delete_file(save_path)
	
	var thumbnail_path: String = get_level_thumbnail_path(level_id, working_folder)
	var new_thumbnail_path: String = get_level_thumbnail_path(level_id, new_folder, false)
	new_thumbnail_path += "." + thumbnail_path.get_extension()
	if file_exists(thumbnail_path):
		move_file(thumbnail_path, new_thumbnail_path)
	
	var music_folder: String = get_level_music_folder(working_folder)
	var new_music_folder: String = get_level_music_folder(new_folder)
	var dir := DirAccess.open(music_folder)
	if dir:
		dir.list_dir_begin()
		
		var file: String = dir.get_next()
		while file != "":
			if not dir.current_is_dir():
				if file.begins_with(level_id):
					move_file(music_folder + "/" + file, new_music_folder + "/" + file)
			file = dir.get_next()
	
	var lss_id: String = LSSLinkHelper.get_id_from_path(file_path)
	if lss_id != "":
		LSSLinkHelper.remove_level_from_link(lss_id)
		LSSLinkHelper.add_level_to_link(lss_id, new_file_path)


static func wipe_level_files(level_id: String, working_folder: String) -> void:
	SortFileHelper.remove_from_sort(level_id, working_folder, SortFileHelper.LEVELS)
	
	var file_path: String = get_level_file_path(level_id, working_folder)
	delete_file(file_path)
	
	for save_slot in range(4):
		var save_path: String = get_level_save_path(level_id, working_folder, save_slot - 1)
		if file_exists(save_path):
			delete_file(save_path)

	var thumbnail_path: String = get_level_thumbnail_path(level_id, working_folder)
	if file_exists(thumbnail_path):
		delete_file(thumbnail_path)
	
	var music_folder: String = get_level_music_folder(working_folder)
	var dir := DirAccess.open(music_folder)
	if dir:
		dir.list_dir_begin()
		
		var file: String = dir.get_next()
		while file != "":
			if not dir.current_is_dir():
				if file.begins_with(level_id):
					delete_file(music_folder + "/" + file)
			file = dir.get_next()
	
	var lss_id: String = LSSLinkHelper.get_id_from_path(file_path)
	if lss_id != "":
		LSSLinkHelper.remove_level_from_link(lss_id)

## FOLDERS
static func get_folder_path(folder_id: String, parent_folder: String) -> String:
	return parent_folder + "/" + folder_id

static func get_valid_folder_name(folder_id: String, parent_folder: String) -> String:
	if DirAccess.dir_exists_absolute(parent_folder + "/" + folder_id):
		return get_valid_folder_name(folder_id + "_", parent_folder)
	return folder_id

static func get_parent_from_path(file_path: String) -> String:
	var index: int = file_path.rfind("/")
	if index != -1:
		return file_path.substr(0, index)
	else:
		return ""

# this retrieves everything after the last "/" in the file path
static func get_last_in_path(file_path: String) -> String:
	var index: int = file_path.rfind("/")
	return file_path.substr(index + 1)

static func create_level_folder(path: String) -> void:
	if not DirAccess.dir_exists_absolute(path):
		#warning-ignore:return_value_discarded
		DirAccess.make_dir_absolute(path)
	else:
		return # not worth wasting time on the rest then
		
	if not DirAccess.dir_exists_absolute(path + "/saves"):
		#warning-ignore:return_value_discarded
		DirAccess.make_dir_absolute(path + "/saves")

	if not DirAccess.dir_exists_absolute(path + "/thumbnails"):
		#warning-ignore:return_value_discarded
		DirAccess.make_dir_absolute(path + "/thumbnails")

	if not DirAccess.dir_exists_absolute(path + "/music"):
		#warning-ignore:return_value_discarded
		DirAccess.make_dir_absolute(path + "/music")
	
	SortFileHelper.save_sort_file(path, {})

static func create_campaign_folder(path: String) -> void:
	if not DirAccess.dir_exists_absolute(path):
		#warning-ignore:return_value_discarded
		DirAccess.make_dir_absolute(path)
	else:
		return # not worth wasting time on the rest then
		
	for i in range(3):
		if not DirAccess.dir_exists_absolute(path + "/saves" + str(i)):
			#warning-ignore:return_value_discarded
			DirAccess.make_dir_absolute(path + "/saves" + str(i))

	if not DirAccess.dir_exists_absolute(path + "/thumbnails"):
		#warning-ignore:return_value_discarded
		DirAccess.make_dir_absolute(path + "/thumbnails")

	if not DirAccess.dir_exists_absolute(path + "/music"):
		#warning-ignore:return_value_discarded
		DirAccess.make_dir_absolute(path + "/music")
	
	var info_dict: Dictionary = CampaignInfoHelper.create_info_dict()
	CampaignInfoHelper.save_info_file(path, info_dict)
	
	SortFileHelper.save_sort_file(path, {})

static func delete_campaign_folder(path: String) -> void:
	var parent_folder: String = get_parent_from_path(path)
	var folder_id: String = get_last_in_path(path)
	SortFileHelper.remove_from_sort(folder_id, parent_folder, SortFileHelper.CAMPAIGNS)
	delete_file(path)

static func rename_campaign_folder(path: String, new_id: String) -> void:
	var parent_folder: String = get_parent_from_path(path)
	var folder_id: String = get_last_in_path(path)
	
	SortFileHelper.remove_from_sort(folder_id, parent_folder, SortFileHelper.CAMPAIGNS)
	SortFileHelper.add_to_sort(new_id, parent_folder, SortFileHelper.CAMPAIGNS)
	
	move_file(path, get_folder_path(new_id, parent_folder))

static func is_campaign(path: String) -> bool:
	return file_exists(path + "/info.json")

static func init_levels_list() -> void:
	if not DirAccess.dir_exists_absolute(BASE_FOLDER):
		create_level_folder(BASE_FOLDER)
	
	var setup_dev: bool = not DirAccess.dir_exists_absolute(DEV_FOLDER)
	if not setup_dev:
		var internal_sort: Dictionary = SortFileHelper.load_internal_sort_file()
		var sort: Dictionary = SortFileHelper.load_sort_file(DEV_FOLDER)
		
		var internal_version: int = internal_sort.get(SortFileHelper.VERSION, -1)
		var version: int = sort.get(SortFileHelper.VERSION, -1)
		
		if internal_version > version:
			print("Version outdated, updating dev levels...")
			setup_dev = true
			for reset_id: String in internal_sort.get("reset_levels", []):
				var save_path: String = get_level_save_path(reset_id, DEV_FOLDER, -1)
				if file_exists(save_path):
					delete_file(save_path)
					print("Save file deleted for level id ", reset_id)
	
	
	if setup_dev:
		create_level_folder(DEV_FOLDER)
		
		var sort: Dictionary = SortFileHelper.load_internal_sort_file()
		var level_sort: Array = sort.get(SortFileHelper.LEVELS, [])
		for level: String in level_sort:
			var level_resource: LevelCodeContainer = load(INTERNAL_DEV_FOLDER + "/" + level + ".tres")
			var level_code: String = level_resource.code
			save_level_code_file(level_code, get_level_file_path(level, DEV_FOLDER))
			
			var thumbnail_path: String = get_level_thumbnail_path(level, INTERNAL_DEV_FOLDER, false) + ".png"
			if ResourceLoader.exists(thumbnail_path):
				var new_thumbnail_path: String = get_level_thumbnail_path(level, DEV_FOLDER, false)
				new_thumbnail_path += ".png"
				
				var texture: Texture2D = load(thumbnail_path)
				texture.get_image().save_png(new_thumbnail_path)
			
		SortFileHelper.save_sort_file(DEV_FOLDER, sort)

static func delete_level_folder(path: String) -> void:
	var parent_folder: String = get_parent_from_path(path)
	var folder_id: String = get_last_in_path(path)
	SortFileHelper.remove_from_sort(folder_id, parent_folder, SortFileHelper.FOLDERS)
	delete_file(path)


static func rename_level_folder(path: String, new_id: String) -> void:
	var parent_folder: String = get_parent_from_path(path)
	var folder_id: String = get_last_in_path(path)
	
	SortFileHelper.remove_from_sort(folder_id, parent_folder, SortFileHelper.FOLDERS)
	SortFileHelper.add_to_sort(new_id, parent_folder, SortFileHelper.FOLDERS)
	
	move_file(path, get_folder_path(new_id, parent_folder))


## LEVEL CODES
static func get_level_file_path(level_id: String, working_folder: String) -> String:
	return working_folder + "/" + level_id + ".127level"

static func load_level_code_file(file_path: String) -> String:
	if not file_exists(file_path):
		printerr("File " + file_path + " does not exist.")
		return ""
	
	var file := FileAccess.open(file_path, FileAccess.READ)
	var err: Error = FileAccess.get_open_error()
	if err != OK:
		printerr("File " + file_path + " failed to load. Error code: " + str(err))
		return ""
	
	var level_code: String = file.get_as_text()
	file.close()
	
	return level_code

static func get_level_code_from_id(level_id: String, working_folder: String) -> String:
	return load_level_code_file(get_level_file_path(level_id, working_folder))
	
static func save_level_code_file(level_code: String, file_path: String) -> void:
	var base_dir: String = file_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(base_dir) and base_dir != "":
		DirAccess.make_dir_recursive_absolute(base_dir)
	
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	var err: Error = FileAccess.get_open_error()
	if err != OK:
		printerr("File " + file_path + " could not be saved. Error code: " + str(err))
		return
	
	file.store_string(level_code)
	file.close()


## SAVE FILES
static func get_save_folder(working_folder: String, selected_file: int = -1) -> String:
	var save_folder: String = "/saves"
	if selected_file == -2: return ""
	if selected_file > -1:
		save_folder += str(selected_file)
	save_folder += "/"
	return working_folder + save_folder

static func get_level_save_path(level_id: String, working_folder: String, selected_file: int = -1) -> String:
	var save_folder: String = get_save_folder(working_folder, selected_file)
	return save_folder + level_id + ".127save"

static func load_level_save_file(file_path: String) -> Dictionary:
	if not file_exists(file_path):
		printerr("File " + file_path + " does not exist.")
		return {}
	
	var file := FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, ENCRYPTION_PASSWORD)
	var err: Error = FileAccess.get_open_error()
	if err != OK:
		printerr("File " + file_path + " failed to load. Error code: " + str(err))
		return {}
	
	var text: String = file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var parse_err: Error = json.parse(text)
	if parse_err != OK:
		printerr(json.get_error_message())
		return {}
	
	var result: Variant = json.get_data()
	if result is Dictionary:
		return result
	return {}

static func save_level_save_file(level_save: Dictionary, file_path: String) -> void:
	var save_json: String = JSON.stringify(level_save)
	var base_dir: String = file_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(base_dir) and base_dir != "":
		DirAccess.make_dir_recursive_absolute(base_dir)
	
	var file := FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, ENCRYPTION_PASSWORD)
	var err: Error = FileAccess.get_open_error()
	if err != OK:
		printerr("File " + file_path + " could not be saved. Error code: " + str(err))
	
	if file:
		file.store_string(save_json)
		file.close()

## THUMBNAILS
const EXTENSIONS: Array[String] = [
	".png",
	".jpg"
]
static func get_level_thumbnail_path(level_id: String, working_folder: String, add_extension: bool = true) -> String:
	var path: String = working_folder + "/thumbnails/" + level_id
	
	if add_extension:
		for extension: String in EXTENSIONS:
			if file_exists(path + extension):
				return path + extension
	return path

static func get_image_from_path(file_path: String) -> ImageTexture:
	var image := Image.load_from_file(file_path)
	var texture := ImageTexture.new()
	if not image:
		printerr("Error loading image at path " + file_path + ".")
	else:
		texture = ImageTexture.create_from_image(image)
	return texture


## MUSIC
static func get_level_music_path(level_id: String, area_id: int, working_folder: String, underwater: bool = false) -> String:
	return get_level_music_folder(working_folder) + level_id + "-" + str(area_id) + str(underwater) + ".ogg"

static func get_level_music_folder(working_folder: String) -> String:
	return working_folder + "/music/"

## AUTOSAVES
static func autosave_level_to_disk(level_code: String, level_path: String) -> void:
	var base_dir: String = level_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(base_dir) and base_dir != "":
		DirAccess.make_dir_recursive_absolute(base_dir)
	
	var file := FileAccess.open(level_path, FileAccess.WRITE)
	var err: Error = FileAccess.get_open_error()
	if err != OK: 
		printerr("File " + level_path + " failed to save. Error code: " + str(err))
	
	var time: float = Time.get_unix_time_from_system()
	if file:
		file.store_string(str(time) + "\n")
		file.store_string(level_code)
		file.close()
