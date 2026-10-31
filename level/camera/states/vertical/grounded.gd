extends CamState

@export var ground_offset: float = -32.0
@export var crouch_offset: float = 80.0
@export var crouch_speed_threshold: float = 10.0

@export var correct_speed: float = 3.0
@export var offset_speed: float = 2.0
@export var air_offset_speed: float = 0.5

var offset: float = 0

### Main logic
func _on_enter() -> void: 
	offset = 0

func _on_exit() -> void: pass

func _update(delta: float) -> void:
	var is_crouching: bool = character.input["crouch"][0] and absf(character.velocity.x) < crouch_speed_threshold
	var target_offset: float = -crouch_offset if is_crouching else -ground_offset
	
	offset = lerpf(offset, target_offset, delta * offset_speed)
	var target_pos: float = lerpf(pos + (offset * zoom), char_pos, delta * correct_speed) - (offset * zoom)
	vel = (target_pos - pos) / delta

func _general_update(delta: float) -> void:
	if camera.vertical_state != self:
		offset = lerpf(offset, 0.0, delta * air_offset_speed)

### Transitions
func _startup_check() -> bool:
	return character.is_grounded()

func _stop_check() -> bool:
	return not _startup_check()
	
func _reset_vars() -> void:
	offset = ground_offset
