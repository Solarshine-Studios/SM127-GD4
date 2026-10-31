extends Label

@export var object_to_watch: Node
@export var property_to_watch: String

func _process(_delta: float) -> void:
	if not is_instance_valid(object_to_watch):
		return
	
	var property: Variant = object_to_watch[property_to_watch]
	if property is Vector2:
		property = "(%.2f, %.2f)" % [property.x, property.y]
	if property is Object:
		property = property.name
	text = str(property)
