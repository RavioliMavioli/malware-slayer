// Mandatory line to define 2D shaders
shader_type canvas_item;

// Allows us to assign a normal map to the shader in the Inspector
uniform sampler2D normal_map;

void fragment(){
	// Converts the texture data into a unit vector, with each channel in the [-1, 1] range

NORMAL = 2.0 * texture(normal_map, UV).rgb - 1.0;
}