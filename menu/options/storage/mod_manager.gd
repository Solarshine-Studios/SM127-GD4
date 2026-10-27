extends Node


const MODS_FOLDER: String = "user://mods"
const ACTIVE_MOD: String = "active.127mod"


@onready var old_data_button: Button = $"%CleanOldData"
@onready var mods_container: Control = $"%ModsContainer"
@onready var none_button: Button = $"%NoMods"


func _ready() -> void:
	if OS.has_feature("JavaScript") or OS.has_feature("mobile"):
		mods_container.hide()
		return
	
	if not DirAccess.dir_exists_absolute(MODS_FOLDER):
		mods_container.hide()
		return
	
	var directory := DirAccess.open(MODS_FOLDER)
	if directory:
		directory.list_dir_begin()
		
		var file: String = directory.get_next()
		while file != "":
			if file != ACTIVE_MOD:
				if file.get_extension() == "zip":
					create_mod_button(file)
			file = directory.get_next()
		directory.list_dir_end()
	
	none_button.disabled = not LevelListHelper.file_exists(MODS_FOLDER + "/" + ACTIVE_MOD)
	none_button.pressed.connect(set_active_mod.bind(""))
	
	check_old_data(false)


func create_mod_button(path: String) -> void:
	var mod_button: Button = none_button.duplicate() as Button
	mod_button.text = path.get_basename()
	mod_button.disabled = (path == ModLoader.path.get_file())
	mod_button.pressed.connect(set_active_mod.bind(path))
	mods_container.call_deferred("add_child", mod_button)


func set_active_mod(new_mod: String) -> void:
	if new_mod != "":
		var file := FileAccess.open(MODS_FOLDER + "/" + ACTIVE_MOD, FileAccess.WRITE)
		if file:
			file.store_line(MODS_FOLDER + "/" + new_mod)
			file.close()
	else:
		DirAccess.remove_absolute("user://mods/active.127mod")
	
	OS.execute(OS.get_executable_path(), [])
	get_tree().quit(0)


func open_appdata() -> void:
	OS.shell_open(OS.get_user_data_dir())


## from versions 0.8 and below
var check_folders: Array[String] = [
	"autosave",
	"hotkeys",
	"levels",
	"template_levels"
]
var check_files: Array[String] = [
	"080.darius",
	"081.dmitri",
	"autosave.txt",
	"bg_music.ogg",
	"LSS.login",
	"settings.json",
	"tiles.res"
]


func check_old_data(delete_data: bool) -> bool:
	var has_old_data: bool = false
	
	for folder in check_folders:
		if DirAccess.dir_exists_absolute("user://" + folder):
			if delete_data: LevelListHelper.delete_file("user://" + folder)
			has_old_data = true
	
	for file_name in check_files:
		if FileAccess.file_exists("user://" + file_name):
			if delete_data: LevelListHelper.delete_file("user://" + file_name)
			has_old_data = true
	
	old_data_button.disabled = (not has_old_data) or delete_data 
	return has_old_data

func clear_cache() -> void:
	pass
