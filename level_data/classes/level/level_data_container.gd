class_name LevelDataContainer
extends LevelDataResource

var level_metadata: LevelHeader
var editor_data: EditorData
var area_headers: Array


func _init(set_level: LevelHeader, set_editor_data: EditorData, set_area_headers: Array) -> void:
	level_metadata = set_level
	editor_data = set_editor_data
	area_headers = set_area_headers
