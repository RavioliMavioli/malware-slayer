shader_type canvas_item;
uniform vec2 center_point;
uniform float force;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;


void fragment() {
	float screen_ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaled_uv = ( SCREEN_UV - vec2(0.5,0) ) / ( vec2(screen_ratio, 1.0) ) + vec2(0.5, 0);
	vec2 disp = normalize(scaled_uv - center_point) * force;
	COLOR = texture(screen_texture, SCREEN_UV - disp);
}
