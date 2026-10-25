extends TextureRect


@export var power: float
@export var speed: float

var time: float = 0.0


func _process(delta: float) -> void:
	time += delta
	offset_transform_position.y = sin(time*speed) * power
