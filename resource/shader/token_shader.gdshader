shader_type spatial;
uniform float playerColorIndex: hint_range(0., 1.,1.) = 0.0;
void fragment() {
	ALBEDO=vec3(1.,playerColorIndex-1.,0.);
	// Place fragment code here.
}
