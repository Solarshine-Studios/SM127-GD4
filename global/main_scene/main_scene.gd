class_name MainScene
extends Control


@onready var backgrounds: PanelContainer = %Backgrounds
@onready var game_container: SubViewportContainer = %GameContainer
@onready var game_viewport: SubViewport = %GameViewport
@export var main_subscene: PackedScene

signal scene_changed


func _ready() -> void:
	change_scene_to_packed(main_subscene)
	get_window().size_changed.connect(update_container_sizing)
	update_container_sizing()


func change_scene_to_packed(packed_scene: PackedScene) -> void:
	_deferred_change_scene.call_deferred(packed_scene)


func _deferred_change_scene(packed_scene: PackedScene) -> void:
	for child in game_viewport.get_children():
		child.queue_free()
	
	var scene_node: Node = packed_scene.instantiate()
	
	game_viewport.add_child(scene_node)
	scene_changed.emit()


func update_container_sizing(scale_mode: int = LocalSettings.load_setting("General", "scale_mode", 0)) -> void:
	if not is_instance_valid(game_container):
		return
	
	var base_size := Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	var window_size: Vector2 = get_window().size
	var scale_x: float = window_size.x / base_size.x
	var scale_y: float = window_size.y / base_size.y
	
	var scaling_factor: float = min(scale_x, scale_y)
	var int_scaling_factor: int = min(scale_x, scale_y)
	var bg_scale_factor: float
	
	var is_integer: bool = (scale_mode == 1)
	if is_integer and int_scaling_factor > 0:
		game_container.custom_minimum_size = base_size * int_scaling_factor
		bg_scale_factor = int_scaling_factor
	else:
		game_container.custom_minimum_size = base_size * scaling_factor
		bg_scale_factor = scaling_factor
	
	backgrounds.scale = Vector2.ONE * bg_scale_factor
	backgrounds.anchor_right = 1.0 / bg_scale_factor
	backgrounds.anchor_bottom = 1.0 / bg_scale_factor
