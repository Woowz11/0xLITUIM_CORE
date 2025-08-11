#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:woowz.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec4 light;
in vec2 texCoord0;

out vec4 fragColor;

void main(){
	vec4 color = texture(Sampler0, texCoord0);
	vec4 color_shadow = color * light * vertexColor * ColorModulator;
	vec4 result = color_shadow;
	
#ifdef ALPHA_CUTOUT
	if (result.a < ALPHA_CUTOUT) { discard; }
#endif
	
	if(color.r > 0.8 && color.g < 0.8 && color.b < 0.8){
		result = mix(color_shadow, vec4(rand(gl_FragCoord.xyz), 0, 0, 1), (color.r - 0.8) * 5);
	}
	if(color.r < 0.8 && color.g > 0.8 && color.b < 0.8){
		result = mix(color_shadow, vec4(0, rand(gl_FragCoord.xyz + vec3(1,1,1)), 0, 1), (color.g - 0.8) * 5);
	}
	if(color.r < 0.8 && color.g < 0.8 && color.b > 0.8){
		result = mix(color_shadow, vec4(0, 0, rand(gl_FragCoord.xyz + vec3(2,2,2)), 1), (color.b - 0.8) * 5);
	}
	
	fragColor = apply_fog(result, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
