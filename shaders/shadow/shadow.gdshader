shader_type canvas_item;

uniform sampler2D color : source_color;
uniform vec2 offset;
uniform float shadow_alpha;

void fragment() {
	vec4 c = texture(color, UV);
	if (c.a < 1.0) {
		vec4 cr = texture(color, UV - offset);
		if (cr.a > 0.0) {
			c.rgb = clamp(c.rgb * c.a + vec3(0.0, 0.0, 0.0) * cr.a * shadow_alpha * (1.0 - c.a), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
			c.a = clamp(c.a + cr.a * shadow_alpha * (1.0 - c.a), 0.0, 1.0);
		}
	}
		
	COLOR = c;
}
