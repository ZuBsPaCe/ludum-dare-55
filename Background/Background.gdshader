shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float height = 1.0 - UV.y;
	vec3 col = mix(vec3(0.141, 0.62, 0.878), vec3(1.0, 1.0, 1.0), height);
	
	COLOR = vec4(col, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
