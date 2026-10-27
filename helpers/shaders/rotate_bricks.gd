@tool
class_name BrickScaleUpdater
extends Control


func _ready() -> void:
	resized()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		resized()

func resized() -> void:
	if material is ShaderMaterial:
		var shader_material: ShaderMaterial = material
		shader_material.set_shader_parameter("control_size", size)
