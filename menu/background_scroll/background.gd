@tool
extends Control

@onready var overlay: Control = $Overlay
@onready var scroll: Control = $Scroll
@onready var gradients: TabContainer = $Gradients

@export var overlay_tint: Color:
	set(new_value):
		overlay_tint = new_value
		if is_inside_tree():
			overlay.modulate = new_value

@export var static_amount: float:
	set(new_value):
		static_amount = new_value
		if is_inside_tree():
			var shader_material: ShaderMaterial = overlay.material.duplicate()
			shader_material.set_shader_parameter("u_amount", new_value)
			overlay.material = shader_material

@export var gradient_style: int:
	set(new_value):
		gradient_style = new_value
		if is_inside_tree():
			gradients.current_tab = new_value


func _ready() -> void:
	overlay.modulate = overlay_tint
	var shader_material: ShaderMaterial = overlay.material.duplicate()
	shader_material.set_shader_parameter("u_amount", static_amount)
	overlay.material = shader_material
	gradients.current_tab = gradient_style


func _process(_delta: float) -> void:
	if not is_visible_in_tree(): return
	scroll.modulate.a = modulate.a
