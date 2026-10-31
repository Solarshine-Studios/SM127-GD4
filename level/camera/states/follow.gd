class_name CamFollowState
extends CamState

@export_group("Character Conditions")
@export var follow_physics: PackedStringArray
@export var follow_actions: PackedStringArray

@export_group("Parameters")
@export var margin: float = 32.0

@export var slow_follow_speed: float = 3.0
@export var follow_speed: float = 6.0
@export var lerp_slower_speed: float = 12.0
@export var lerp_faster_speed: float = 12.0

@export var speed_threshold: float = 120.0
@export var max_speed: float = 500.0
@export var max_lead_distance: float = 280.0
@export var lead_speed: float = 1.25

var cur_lead_offset: float = 0

### Main logic
func _on_enter() -> void: pass
func _on_exit() -> void: pass

func _update(delta: float) -> void:
	var target_lead: float = 0.0

	if char_speed > speed_threshold:
		var speed_factor: float = clampf((char_speed - speed_threshold) / (max_speed - speed_threshold), 0.0, 1.0)
		target_lead = max_lead_distance * speed_factor * signf(char_vel)
		target_lead *= zoom

	cur_lead_offset = lerpf(cur_lead_offset, target_lead, delta * lead_speed)
	
	var diff: float = char_center_dist + cur_lead_offset
	var abs_diff: float = absf(diff)
	var zoomed_margin: float = margin * zoom
	
	if abs_diff > zoomed_margin:
		var clamped_diff: float = diff - (signf(diff) * zoomed_margin)
		var target_pos: float = lerpf(pos, pos + clamped_diff, delta * follow_speed)
		var target_vel: float = (target_pos - pos) / delta
		var lerp_speed: float = lerp_faster_speed if absf(target_vel) < absf(vel) else lerp_slower_speed
		vel = lerpf(vel, target_vel, delta * lerp_speed)
	else:
		vel = lerpf(vel, 0.0, delta * lerp_slower_speed)

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

func _reset_vars() -> void:
	cur_lead_offset = 0
