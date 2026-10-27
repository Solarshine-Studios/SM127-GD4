extends GridContainer


func _ready() -> void:
	if columns != 2:
		printerr("Number of columns is not 2! Neighbors will not be autoset.")
	
	var child_count: int = get_child_count()
	for index: int in range(child_count):
		if get_child(index) is KeybindButton:
			var keybind_button: KeybindButton = get_child(index)
			if index + 2 < child_count:
				var bottom_button: Button = (get_child(index + 2) as KeybindButton).button
				keybind_button.button.focus_neighbor_bottom = keybind_button.button.get_path_to(bottom_button)
