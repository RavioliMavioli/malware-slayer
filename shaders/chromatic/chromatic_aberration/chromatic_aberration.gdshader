shader_type canvas_item;

uniform float strength_x = 2.0;
uniform float strength_y = 2.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment(){
	vec2 offset = vec2(strength_x, strength_y) * SCREEN_PIXEL_SIZE;
	float R = texture(SCREEN_TEXTURE, SCREEN_UV - offset).r;
	float G = texture(SCREEN_TEXTURE, SCREEN_UV			).g;
	float B = texture(SCREEN_TEXTURE, SCREEN_UV + offset).b;
	
	float value = distance(UV, vec2(0.5));
	COLOR = vec4(R, G, B, 1);
}