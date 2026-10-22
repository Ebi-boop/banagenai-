shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 top_color = vec4(0.10, 0.65, 1.0, 0.97);
	vec4 bottom_color = vec4(0.10, 1.0, 0.4, 0.97);
	
	COLOR = mix(top_color, bottom_color, UV.y);
}
//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
