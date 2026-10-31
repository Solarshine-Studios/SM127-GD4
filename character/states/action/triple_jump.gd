class_name TripleJumpAction
extends ActionState


const TILE_SIZE: int = 32

@export var launch_power: float
@export var jump_height: float
@export var somersault_physics: PhysicsState

var jump_released: bool = false
const HEIGHT_MULT: float = 0.7


## jump heights are tracked in tiles here, not velocity
## this makes em easy to track and easy to tweak :)
func get_jump_power() -> float:
	var gravity_per_sec: float = character.get_gravity_sum() / get_physics_process_delta_time() 
	return sqrt(jump_height * gravity_per_sec * TILE_SIZE * 2)


### Main logic

## runs once when this state begins being active
func _on_enter() -> void:
	jump_released = false
	character.velocity.x += launch_power * character.facing_direction
	character.velocity.y = min(-get_jump_power(), character.velocity.y)
	character.set_state("physics", somersault_physics)


## runs every frame while active
func _update(_delta: float) -> void:
	## jump height variation
	if not jump_released and not character.input["jump"][0]:
		jump_released = true
		character.velocity.y *= HEIGHT_MULT


### Transitions

## runs this check every frame while active
## the string returned is the name of the state to change to
## return self.name for no change!
func _transition_check() -> String:
	if character.velocity.y > 2 or character.physics is GroundPhysics:
		return ""
	return name
