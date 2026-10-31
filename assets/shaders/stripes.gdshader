shader_type canvas_item;

uniform float angle = 60.0;
uniform float line_count = 400.0; 
uniform float speed = 3.0; 
uniform float blur : hint_range(0.0, 2.0, 0);

varying vec4 modulate_color;

void vertex() {
    modulate_color = COLOR;
}

vec2 rotate(vec2 current_uv, float rotation_angle) {
	float radians_angle = radians(rotation_angle);
	float cos_angle = cos(radians_angle);
	float sin_angle = sin(radians_angle);
	mat2 rotation_matrix = mat2(vec2(cos_angle, -sin_angle), vec2(sin_angle, cos_angle));
	return current_uv * rotation_matrix;
}

float stripe(vec2 current_uv) {
	return cos(current_uv.x * 0.0 - TIME * speed + current_uv.y * -line_count / 2.0);
}

void fragment() {
	vec2 current_uv = UV;
	vec2 texture_resolution = 1.0 / TEXTURE_PIXEL_SIZE;
	float aspect_ratio = TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y;
	current_uv.x *= aspect_ratio;
	current_uv = rotate(current_uv, angle);
	float stripe_value = stripe(current_uv);
	float alpha = mix(1.0, 0.0, smoothstep(0.0, blur, stripe_value));
	COLOR = vec4(COLOR.rgb, alpha * pow(modulate_color.a, 3)) * modulate_color;
}