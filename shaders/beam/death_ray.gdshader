shader_type canvas_item;
uniform float speed : hint_range(0.0, 5.0, 0.1) = 3.0;
uniform vec4 color: source_color;
uniform float strength : hint_range(0.0, 1.0, 0.01) = 1.0;

float line(vec2 uv, float t) {
	uv.x = 0.0;
	float il = length(uv-0.5);
	float l = smoothstep(0.7+sin(t*5.0)*.0075,0.4,il);
	l += smoothstep(0.505,0.5,il)/2.;
	return l;
}

float wobble(vec2 uv, float t, float amp, float freq, float width) {
	float il = length(vec2(uv.y-0.5)+sin((uv.x-t)*freq)*amp);
	float l = smoothstep(width,width-0.05,il);
	return l;
}

void fragment() {
	vec3 col = color.rgb;
	float fx = line(UV, TIME*speed);
	fx += wobble(UV, TIME*speed*2.0, 0.1, 10.0, 0.04);
	fx += wobble(UV, TIME*speed*1.456, 0.3, 12.0, 0.03);
	fx += wobble(UV, TIME*speed*0.876, 0.2, 14.0, 0.025);
	fx += wobble(UV, TIME*speed, 0.15, 8.0, 0.03);
	
	col *= fx;
	if (fx > 1.0)
		col.gb += col.r/2.0;

	COLOR = vec4(col,fx);
}