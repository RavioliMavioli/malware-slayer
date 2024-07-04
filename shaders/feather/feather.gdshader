shader_type spatial;

render_mode unshaded;

uniform sampler2D tex : source_color;  // Texture, used as color

uniform float radius = 0.3; // Radius of the circle
uniform float feather = 0.05; // Feathering of the circles edge

uniform vec2 center = vec2(0.5, 0.5); // Center (Adjust to move the circle around)

float circle_mask(vec2 _uv, vec2 _center, float _radius, float _feather) {
    float dist = length(_uv - _center); // Distance from current pixel to the center
    return smoothstep(_radius, _radius - _feather, dist); // Smooth transition
}

void fragment() {
    ALPHA = circle_mask(UV, center, radius, feather); // Use mask for transparency
    ALBEDO = texture(tex, UV).rgb;; // Set the albedo to the texture color
}