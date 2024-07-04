shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform bool overlay = false;
uniform bool multiply = false;
uniform bool screen = false;
uniform bool darken = false;
uniform bool lighten = false;
uniform bool difference = false;
uniform bool exclusion = false;
uniform bool hard_light = false;
uniform bool soft_light = false;
uniform bool color_dodge = false;
uniform bool linear_dodge = false;
uniform bool color_burn = false;
uniform bool linear_burn = false;

vec4 _overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}
vec4 _multiply(vec4 base, vec4 blend){
	return base * blend;
}
vec4 _screen(vec4 base, vec4 blend){
	return 1.0 - (1.0 - base) * (1.0 - blend);
}
vec4 _darken(vec4 base, vec4 blend){
	return min(base, blend);
}
vec4 _lighten(vec4 base, vec4 blend){
	return max(base, blend);
}
vec4 _difference(vec4 base, vec4 blend){
	return abs(base - blend);
}
vec4 _exclusion(vec4 base, vec4 blend){
	return base + blend - 2.0 * base * blend;
}
vec4 _hard_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}
vec4 _soft_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}
vec4 _color_dodge(vec4 base, vec4 blend){
	return base / (1.0 - blend);
}
vec4 _linear_dodge(vec4 base, vec4 blend){
	return base + blend;
}
vec4 _color_burn(vec4 base, vec4 blend){
	return 1.0 - (1.0 - base) / blend;
}
vec4 _linear_burn (vec4 base, vec4 blend){
	return base + blend - 1.0;
}


void fragment() {
	vec4 screen_tex = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	if (overlay){ COLOR = _overlay(screen_tex, COLOR);}
	if (multiply){ COLOR = _multiply(screen_tex, COLOR);}
	if (screen){ COLOR = _screen(screen_tex, COLOR);}
	if (darken){ COLOR = _darken(screen_tex, COLOR);}
	if (lighten){ COLOR = _lighten(screen_tex, COLOR);}
	if (difference){ COLOR = _difference(screen_tex, COLOR);}
	if (exclusion){ COLOR = _exclusion(screen_tex, COLOR);}
	if (hard_light){ COLOR = _hard_light(screen_tex, COLOR);}
	if (soft_light){ COLOR = _soft_light(screen_tex, COLOR);}
	if (color_dodge){ COLOR = _color_dodge(screen_tex, COLOR);}
	if (linear_dodge){ COLOR = _linear_dodge(screen_tex, COLOR);}
	if (color_burn){ COLOR = _color_burn(screen_tex, COLOR);}
	if (linear_burn){ COLOR = _linear_burn(screen_tex, COLOR);}
}
