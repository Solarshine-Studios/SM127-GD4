shader_type canvas_item;

uniform float rotation_angle : hint_range(0.0, 360.0) = 15.0;
uniform vec2 control_size = vec2(768.0, 432.0);
uniform vec2 tile_size = vec2(24.0, 24.0);

varying vec4 modulate_color;

void vertex() {
    modulate_color = COLOR;
}

void fragment() {
	vec2 aspect_scale = control_size / tile_size;
	vec2 uv = (UV - vec2(0.5)) * aspect_scale;

	float rad = radians(rotation_angle);
	float cos_a = cos(rad);
	float sin_a = sin(rad);
	mat2 rot = mat2(vec2(cos_a, -sin_a), vec2(sin_a, cos_a));
	uv = rot * uv;

	COLOR = texture(TEXTURE, uv) * modulate_color;
}