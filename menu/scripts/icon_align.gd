@tool
extends TextureRect

signal offset_changed

@export var countdown: PressCountdown
@export var disabled_color: Color = Color.WHITE
@export var offset: Vector2:
	set(new_value):
		offset = new_value
		emit_signal("offset_changed")

@onready var parent: Button = get_parent()


func _ready() -> void:
	if parent:
		parent.resized.connect(update_offset)
		parent.mouse_entered.connect(update_offset)
		parent.mouse_exited.connect(update_offset)
		parent.button_down.connect(update_offset)
		parent.button_up.connect(update_offset)
	if countdown and not Engine.is_editor_hint():
		countdown.text_changed.connect(update_offset)
	offset_changed.connect(update_offset)
	update_offset.call_deferred()


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		update_offset.call_deferred()


func update_offset() -> void:
	var viewport: Viewport = get_viewport()
	if not is_instance_valid(viewport):
		return
	
	var is_focused: bool = viewport.gui_get_focus_owner() == parent
	
	var style: String = "normal"
	self_modulate = parent.get_theme_color(&"icon_normal_color")
	if parent.disabled:
		style = "disabled"
		self_modulate = parent.get_theme_color(&"icon_disabled_color")
	elif parent.is_hovered() or is_focused:
		if parent.button_pressed:
			style = "pressed"
			self_modulate = parent.get_theme_color(&"icon_pressed_color")
		elif not is_focused:
			style = "hover"
			self_modulate = parent.get_theme_color(&"icon_hover_color")
	
	var stylebox: StyleBox = parent.get_theme_stylebox(style)
	var padding_left: float = maxf(0.0, stylebox.get_content_margin(SIDE_LEFT) if stylebox else 0.0)
	var padding_right: float = maxf(0.0, stylebox.get_content_margin(SIDE_RIGHT) if stylebox else 0.0)
	var padding_top: float = maxf(0.0, stylebox.get_content_margin(SIDE_TOP) if stylebox else 0.0)
	var padding_bottom: float = maxf(0.0, stylebox.get_content_margin(SIDE_BOTTOM) if stylebox else 0.0)
	
	if stylebox is StyleBoxTexture:
		var texbox: StyleBoxTexture = stylebox
		padding_left += texbox.texture_margin_left
		padding_right += texbox.texture_margin_right
		padding_top += texbox.texture_margin_top
		padding_bottom += texbox.texture_margin_bottom
	
	var font: Font = parent.get_theme_font("font")
	var font_size: int = parent.get_theme_font_size("font_size")
	var text_width: float = font.get_string_size(tr(parent.text), HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	
	var available_width: float = parent.size.x - padding_left - padding_right
	var text_left: float = padding_left
	
	match parent.alignment:
		HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER:
			text_left = padding_left + (available_width - text_width) / 2.0
		HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT:
			text_left = padding_left
		HorizontalAlignment.HORIZONTAL_ALIGNMENT_RIGHT:
			text_left = parent.size.x - padding_right - text_width
	
	if not parent.text.is_empty():
		position.x = text_left + offset.x - size.x
	else:
		position.x = (parent.size.x / 2.0) - (size.x / 2.0)
	
	position.y = (parent.size.y / 2.0) - (size.y / 2.0)
	position.y += (padding_top - padding_bottom) / 2.0
	position.y += offset.y
