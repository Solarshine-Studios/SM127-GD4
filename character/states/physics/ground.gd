class_name GroundPhysics
extends PhysicsState

@export_group("Ground Movement")
@export var move_speed: float = 216.0
@export var acceleration: float = 16.0
@export var overshoot_speed: float = 3.5
@export var turn_speed: float = 30.0
@export var friction: float = 27.0

@export_group("Misc")
@export var set_facing: bool = true
@export var idle_threshold: float
@export var air_name: String

### Movement logic
func do_movement(move_dir: int) -> void:
	var relative_vel: float = character.velocity.x * move_dir
	var factor: float
	
	# changing direction
	if relative_vel < 0:
		factor = turn_speed
	# accelerating to top speed
	elif relative_vel < move_speed:
		factor = acceleration
	# correcting down to top speed
	elif relative_vel > move_speed:
		factor = overshoot_speed
	
	character.velocity.x = move_toward(character.velocity.x, move_speed * move_dir, factor)
	
	if set_facing:
		character.facing_direction = move_dir

func do_friction() -> void:
	character.velocity.x = move_toward(character.velocity.x, 0, friction)

### Main logic
func _on_enter() -> void: pass
func _on_exit() -> void: pass

func _update(_delta: float) -> void:
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
	
	## Animation
	var current_speed: float = abs(character.velocity.x)
	if current_speed > idle_threshold and not character.is_walled():
		anim_speed = 1
		if current_speed > move_speed:
			anim_speed = current_speed / move_speed
		animation = "walk"
	else:
		anim_speed = 1
		animation = "idle"
	
	## Coyote time
	character.container_override = self
	character.override_timer = 0.125

func _general_update(_delta: float) -> void: pass

### Transitions
func _startup_check() -> bool:
	return character.is_grounded()

func _transition_check() -> String:
	if not character.is_grounded():
		return air_name
	return name
