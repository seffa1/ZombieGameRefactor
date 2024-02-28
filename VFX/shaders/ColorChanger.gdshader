shader_type canvas_item;
uniform float blue = 1.0; // you can assign a default value to uniforms
uniform float red = 1.0; // you can assign a default value to uniforms
uniform float green = 0.0; // you can assign a default value to uniforms

void fragment() {
	// Place fragment code here.
	// COLOR = vec4(0.4, 0.6, 0.9, 1.0);
	COLOR = texture(TEXTURE, UV); // Read from texture again.
	COLOR.b = blue;
	COLOR.r = red;
	COLOR.g = green;
}
