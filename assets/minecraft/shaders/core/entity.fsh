#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:woowz.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in float damage;
in vec2 texCoord0;

out vec4 fragColor;

void main() {
	vec4 color = texture(Sampler0, texCoord0);
	
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
	color *= vertexColor * ColorModulator;
#ifndef NO_OVERLAY
	vec3 damageColor = vec3(rand(gl_FragCoord.xyz)) - color.rgb;
	damageColor.g *= 2;
	color.rgb = mix(damageColor, color.rgb, clamp(damage * damage * damage * damage * damage * damage, 0 ,1));
#endif
#ifndef EMISSIVE
	float total = min(lightMapColor.r + lightMapColor.g + lightMapColor.b, 1);
	color.r = mix(rand(gl_FragCoord.xyz + lightMapColor.rgb), color.r, total);
	color.g = mix(0, color.g, total);
	color.b = mix(0, color.b, total);
#endif
	fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
