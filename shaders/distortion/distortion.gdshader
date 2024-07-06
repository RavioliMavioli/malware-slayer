shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float chrom: hint_range(0.0, 10.0, 0.1) = 0.0;
uniform float strength: hint_range(0.0, 20.0, 0.1) = 3.0;
uniform float size: hint_range(0.0, 5.0, 1.0) = 1.0;
uniform bool enable = true;
uniform sampler2D noise_tex;

float random( float seed ){
	return fract( 543.2543 * sin( dot( vec2( seed, seed ), vec2( 3525.46, -54.3415 ) ) ) );
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 final_tex;
	vec4 dist;

	float rng = random(TIME) * float(enable);
	float noise = texture(noise_tex, UV).b;
	
	noise = round(noise * size) / size;

	uv.x += noise * rng * strength / 100.0;
	uv.x = fract(uv.x);
	uv.y -= noise * rng * strength / 50.0;
	
	if (noise == 0.0){
		uv.x -= rng * strength / 40.0;
		uv.x = fract(uv.x);
		uv.y += noise * rng * strength / 20.0;
	}
	
	dist = textureLod( SCREEN_TEXTURE, uv, 0.0 );
	dist.r = textureLod( SCREEN_TEXTURE, uv + (rng * chrom / 100.0), 0.0 ).r;
	dist.b = textureLod( SCREEN_TEXTURE, uv - (rng * chrom / 100.0), 0.0 ).b;
	COLOR = dist;
}
