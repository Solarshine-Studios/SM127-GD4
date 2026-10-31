extends AirPhysics

@export var air_name: String

### Transitions
func _startup_check() -> bool:
	return false

func _transition_check() -> String:
	if character.velocity.y > 0:
		return air_name
	return super()
