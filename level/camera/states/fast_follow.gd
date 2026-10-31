extends CamState

@export var follow_physics: PackedStringArray
@export var follow_actions: PackedStringArray
@export var cam_lead_amount: float = 15.0
@export var follow_speed: float = 4.0

var last_char_pos: float

### Main logic
func _on_enter() -> void:
	last_char_pos = char_pos

func _on_exit() -> void: pass

func _update(delta: float) -> void:
	var target_pos: float = char_pos
	var movement: float = target_pos - last_char_pos
	target_pos += movement * cam_lead_amount
	pos = lerpf(pos, target_pos, delta * follow_speed)
	vel = 0.0
	last_char_pos = char_pos

func _general_update(_delta: float) -> void: pass

### Transitions
func _startup_check() -> bool:
	if follow_physics.is_empty() and follow_actions.is_empty():
		return true
	
	var is_physics: bool = is_instance_valid(character.physics) and character.physics.name in follow_physics
	var is_action: bool = is_instance_valid(character.action) and character.action.name in follow_actions
	return is_physics or is_action

func _stop_check() -> bool:
	return not _startup_check()

func _reset_vars() -> void: pass
