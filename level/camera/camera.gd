class_name CharacterCamera 
extends Camera2D

@export var character: Character
## so that the camera can follow the character's center, rather than their base
@export var follow_offset: Vector2

@onready var horizontal_state_container: Node = %HorizontalStates
@onready var vertical_state_container: Node = %VerticalStates

var horizontal_state: CamState
var vertical_state: CamState

var char_pos: Vector2:
	get:
		return character.global_position + follow_offset
	
var velocity: Vector2
var size: Vector2
var base_size: Vector2:
	get:
		var x_size: float = ProjectSettings.get_setting("display/window/size/viewport_width")
		var y_size: float = ProjectSettings.get_setting("display/window/size/viewport_height")
		return Vector2(x_size, y_size) / 2

func _ready() -> void:
	if is_instance_valid(character):
		global_position = char_pos

func _physics_process(delta: float) -> void:
	if is_instance_valid(character):
		character_follow(delta)
	
	update_shape_size()
	global_position += velocity * delta

func character_follow(delta: float) -> void:
	## runs the same code for handling horizontal and vertical states, in that order
	for i in range(2):
		var container: Node = horizontal_state_container if i == 0 else vertical_state_container
		var property: String = "horizontal_state" if i == 0 else "vertical_state"
		var cur_state: CamState = self[property]
		
		if is_instance_valid(cur_state):
			cur_state.character = character
			cur_state._update(delta)
			if cur_state._stop_check():
				cur_state._on_exit()
				self[property] = null
		
		for check_state: CamState in container.get_children():
			check_state.character = character
			var priority_check: bool = not is_instance_valid(cur_state) or check_state.priority >= cur_state.priority
			if check_state != cur_state and priority_check and check_state._startup_check():
				if is_instance_valid(cur_state):
					cur_state._on_exit()
				self[property] = check_state
				check_state._on_enter()
			check_state._general_update(delta)

func update_shape_size() -> void:
	size = base_size * zoom.y
