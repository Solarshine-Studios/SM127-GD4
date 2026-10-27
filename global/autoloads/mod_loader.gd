extends Node
## Loads the active mod resource pack on boot and exposes its state.

const ACTIVE_MOD_FILE: String = "user://mods/active.127mod"

var active: bool = false
var path: String = ""


func _init() -> void:
	var file: FileAccess = FileAccess.open(ACTIVE_MOD_FILE, FileAccess.READ)
	if file:
		path = file.get_line()
		active = true

func load_mod() -> void:
	active = ProjectSettings.load_resource_pack(path)
