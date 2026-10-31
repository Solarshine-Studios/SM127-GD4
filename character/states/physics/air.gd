class_name AirPhysics
extends PhysicsState

@export_group("Air Movement")
@export var move_speed: float = 216.0
@export var acceleration: float = 16.0
@export var overshoot_speed: float = 0.25
@export var friction: float = 2.3
@export var overshoot_friction: float = 4.6

@export_group("Misc")
@export var max_fall_speed: float = 640.0
@export var set_facing: bool = true
@export var ground_name: String

### Movement logic
func do_movement(move_dir: int) -> void:
	var relative_vel: float = character.velocity.x * move_dir
	var factor: float
	
	# accelerating to top speed
	if relative_vel < move_speed:
		factor = acceleration
	# correcting down to top speed
	elif relative_vel > move_speed:
		factor = overshoot_speed
	
	character.velocity.x = move_toward(character.velocity.x, move_speed * move_dir, factor)
	
	if set_facing:
		character.facing_direction = move_dir

func do_friction() -> void:
	var working_friction: float = friction
	if abs(character.velocity.x) > move_speed:
		working_friction = overshoot_friction
	
	character.velocity.x = move_toward(character.velocity.x, 0, working_friction)

### Main logic
func _on_enter() -> void: pass

func _on_exit() -> void:
	animation = "fall"
	anim_is_directional = true

func _update(_delta: float) -> void:
	## Gravity
	var total_gravity: float = character.get_gravity_sum()
	character.velocity.y += total_gravity
	character.velocity.y = minf(character.velocity.y, max_fall_speed)
	
	## Movement
	var move_dir: int = 0
	if character.input["left"][0]: 
		move_dir -= 1
	if character.input["right"][0]: 
		move_dir += 1
	
	if move_dir != 0:
		do_movement(move_dir)
	else:
		do_friction()

func _general_update(_delta: float) -> void: pass

### Transitions
func _startup_check() -> bool:
	return not character.is_grounded()

func _transition_check() -> String:
	if character.is_grounded():
		return ground_name
	return name
