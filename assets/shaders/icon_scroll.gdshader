shader_type canvas_item;

uniform float speed = 0.24;
uniform float direction = -1;

varying vec4 modulate_color;

void vertex() {
    modulate_color = COLOR;
}

void fragment () {
	COLOR = texture(TEXTURE, vec2(UV.x + TIME * speed * direction, UV.y + TIME * speed * direction)) * modulate_color;
}