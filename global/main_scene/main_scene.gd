class_name MainScene
extends Control


@onready var game_viewport: SubViewport = %GameViewport
@export var main_subscene: PackedScene

signal scene_changed


func _ready() -> void:
	change_scene_to_packed(main_subscene)


func change_scene_to_packed(packed_scene: PackedScene) -> void:
	_deferred_change_scene.call_deferred(packed_scene)


func _deferred_change_scene(packed_scene: PackedScene) -> void:
	for child in game_viewport.get_children():
		child.queue_free()
	
	var scene_node: Node = packed_scene.instantiate()
	
	game_viewport.add_child(scene_node)
	scene_changed.emit()
