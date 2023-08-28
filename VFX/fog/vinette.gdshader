shader_type canvas_item;

uniform vec4 color: source_color;
uniform float multiplier = 0.3;
uniform float softness = .6;

void fragment(){
	float value = distance(UV, vec2(0.5));
	COLOR = vec4(color.rgb, smoothstep(multiplier, softness, value));
}