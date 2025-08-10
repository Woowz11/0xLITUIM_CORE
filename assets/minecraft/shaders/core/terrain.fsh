#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

float rand(vec3 seed){
	return (fract(sin(dot(seed, vec3(12.9898, 78.233, 151.7182))) * 43758.5453) - 0.5) * 2;
}

void main(){
	vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
	
	if(color.r > 0.8 && color.g < 0.8 && color.b < 0.8){
		color = mix(color, vec4(rand(gl_FragCoord.xyz), 0, 0, 1), (color.r - 0.8) * 5);
	}
	if(color.r < 0.8 && color.g > 0.8 && color.b < 0.8){
		color = mix(color, vec4(0, rand(gl_FragCoord.xyz + vec3(1,1,1)), 0, 1), (color.g - 0.8) * 5);
	}
	if(color.r < 0.8 && color.g < 0.8 && color.b > 0.8){
		color = mix(color, vec4(0, 0, rand(gl_FragCoord.xyz + vec3(2,2,2)), 1), (color.b - 0.8) * 5);
	}
	
#ifdef ALPHA_CUTOUT
	if (color.a < ALPHA_CUTOUT) { discard; }
#endif
	fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
