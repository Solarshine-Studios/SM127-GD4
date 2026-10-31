class_name JumpAction
extends ActionState

const TILE_SIZE: int = 32

@export var jump_heights: Array[float]
@export var jump_animations: Array[String]
@export var jump_is_directional: Array[bool]
@export var fall_animations: Array[String]
@export var fall_is_directional: Array[bool]
@export var triple_jump_threshold: float
@export var triple_jump_action: ActionState
@export var air_physics: PhysicsState
@export var max_jumps: int

var jump_sequence: int
var reset_timer: float
var pressed_buffer: float

var jump_released: bool = false
const HEIGHT_MULT: float = 0.7

## jump heights are tracked in tiles here, not velocity
## this makes em easy to track and easy to tweak :)
func get_jump_power(jump_height: float) -> float:
	var gravity_per_sec: float = character.BASE_GRAVITY / get_physics_process_delta_time() 
	return sqrt(jump_height * gravity_per_sec * TILE_SIZE * 2)

### Main logic
func _on_enter() -> void:
	jump_released = false
	character.override_timer = 0
	
	## triple jump
	if jump_sequence >= max_jumps - 1 and abs(character.velocity.x) > triple_jump_threshold:
		character.set_state("action", triple_jump_action)
		reset_timer = 0
	## single and double jump
	else:
		jump_sequence = min(jump_sequence, max_jumps - 2)
		
		animation = jump_animations[jump_sequence]
		anim_is_directional = jump_is_directional[jump_sequence]
		
		air_physics.animation = fall_animations[jump_sequence]
		air_physics.anim_is_directional = fall_is_directional[jump_sequence]
		
		character.set_state("physics", air_physics)
		
		var jump_power: float = get_jump_power(jump_heights[jump_sequence])
		character.velocity.y = min(-jump_power, character.velocity.y)
	
	jump_sequence += 1
	reset_timer = 0.175
	if jump_sequence >= max_jumps:
		jump_sequence = 0
		reset_timer = 0

func _on_exit() -> void: pass

func _update(_delta: float) -> void:
	## jump height variation
	if not jump_released and not character.input["jump"][0]:
		jump_released = true
		character.velocity.y *= HEIGHT_MULT

func _general_update(delta: float) -> void:
	var jump_just_pressed: bool = character.input["jump"][1]
	if jump_just_pressed:
		pressed_buffer = 0.075
	else:
		pressed_buffer -= delta
	
	if character.is_grounded():
		reset_timer -= delta
		reset_timer = max(reset_timer, 0)
		if reset_timer == 0:
			jump_sequence = 0

### Transitions
func _startup_check() -> bool:
	return pressed_buffer > 0

func _transition_check() -> String:
	if character.velocity.y > 2 or character.physics is GroundPhysics:
		return ""
	return name
