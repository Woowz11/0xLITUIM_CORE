#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:woowz.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec2 texCoord0;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
	vec4 color = texture(Sampler0, texCoord0);
	vec4 color_shadow = color * vertexColor * ColorModulator;
	vec4 result = color_shadow;
	
	if(color.r == 0 && color.g == 1 && color.b == 0){
		result = vec4(0,rand(gl_FragCoord.xyz),0,color.a);
	}
	
	if (result.a < 0.1) { discard; }
	fragColor = apply_fog(result, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
