@abstract
class_name CamState
extends Node

### Setup
var camera: CharacterCamera
var character: Character:
	get:
		return camera.character

@export var priority: int = -1
@export_enum("x", "y") var axis: String = "y"

var pos: float:
	set(new_val):
		camera.global_position[axis] = new_val
	get:
		return camera.global_position[axis]

var vel: float:
	set(new_val):
		camera.velocity[axis] = new_val
	get:
		return camera.velocity[axis]

var size: float:
	get:
		return camera.size[axis]

var zoom: float:
	get:
		return camera.zoom[axis]

var char_pos: float:
	get:
		return camera.char_pos[axis]

var char_vel: float:
	get:
		return character.velocity[axis]

var char_speed: float:
	get:
		return absf(character.velocity[axis])

var char_center_dist: float:
	get:
		return char_pos - pos

func _enter_tree() -> void:
	camera = get_owner()

## runs once when this state begins being active
@abstract func _on_enter() -> void

## runs once when this state stops being active
@abstract func _on_exit() -> void

## runs every frame while active
@abstract func _update(_delta: float) -> void

## always runs no matter what, before any of the other functions
@abstract func _general_update(_delta: float) -> void

## runs this check every frame while inactive and 
## in the character's current pool of states
@abstract func _startup_check() -> bool

## runs this check every frame while active
@abstract func _stop_check() -> bool

## runs this every time the camera needs to teleport to the player
@abstract func _reset_vars() -> void
