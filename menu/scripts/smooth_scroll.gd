extends ScrollContainer


const SNAP_THRESHOLD: float = 0.1
const LERP_THRESHOLD: float = 4.0
@export var lerp_speed: float = 12

var target_scroll: float = -1.0
var last_scroll: float = 0.0
var smoothing: bool = true
var child: Control = null


func _process(delta: float) -> void:
	if smoothing and abs(last_scroll - float(scroll_vertical)) > LERP_THRESHOLD:
		target_scroll = float(scroll_vertical)
		scroll_vertical = int(last_scroll)
	
	if target_scroll > -1.0:
		scroll_vertical = int(lerp(float(scroll_vertical), target_scroll, delta * lerp_speed))
		if abs(target_scroll - float(scroll_vertical)) < SNAP_THRESHOLD:
			scroll_vertical = int(target_scroll)
			target_scroll = -1.0
	
	if not is_instance_valid(child):
		child = get_child(0)
	
	last_scroll = float(scroll_vertical)


func _ready() -> void:
	follow_focus = false
	get_viewport().gui_focus_changed.connect(gui_focus_changed)
	get_tree().node_added.connect(pass_touch)
	pass_touch(self)


func pass_touch(node: Node) -> void:
	if node is Control and (node as Control).mouse_filter == Control.MOUSE_FILTER_STOP and is_ancestor_of(node) \
			and not (node is Range or node is TextEdit):
		(node as Control).mouse_filter = Control.MOUSE_FILTER_PASS
	for c: Node in node.get_children():
		pass_touch(c)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		smoothing = false
		target_scroll = -1.0
	elif event is InputEventKey or event is InputEventJoypadButton or event is InputEventJoypadMotion \
			or (event is InputEventMouseButton and (event as InputEventMouseButton).button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]):
		smoothing = true


@export var custom_follow_focus: bool
func gui_focus_changed(control: Control) -> void:
	if not custom_follow_focus: return
	if not is_visible_in_tree(): return
	if LastInputDevice.is_mouse: return
	if not is_ancestor_of(control): return
	
	var local_position: Vector2 = (control.global_position - global_position) + Vector2(scroll_horizontal, scroll_vertical)
	scroll_vertical = int((local_position.y + control.size.y) - size.y / 2.0)
