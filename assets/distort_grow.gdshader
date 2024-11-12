shader_type spatial;

render_mode unshaded;

uniform sampler2D screen_tex : hint_screen_texture;
uniform sampler2D noise : repeat_enable;

void vertex() {
	VERTEX += NORMAL * 0.2;
}

void fragment() {
	vec2 u = SCREEN_UV;

	float distortion = pow( textureLod(noise, (u + TIME*.4) * vec2(.04,1), 0.0).x, 7.0);

	//u += distortion * .1;

	vec4 samp = vec4(texture(screen_tex, u).r,texture(screen_tex, u).g,texture(screen_tex, u).b, 1.0);

	ALBEDO = samp.rgb - 0.11;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
