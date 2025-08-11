#version 150

layout(std140) uniform Fog {
	vec4 FogColor;
	float FogEnvironmentalStart;
	float FogEnvironmentalEnd;
	float FogRenderDistanceStart;
	float FogRenderDistanceEnd;
	float FogSkyEnd;
	float FogCloudsEnd;
};

float linear_fog_value(float vertexDistance, float fogStart, float fogEnd) {
	if (vertexDistance <= fogStart) { return 0; } else if (vertexDistance >= fogEnd) { return 1; }

	return (vertexDistance - fogStart) / (fogEnd - fogStart);
}

float total_fog_value(float sphericalVertexDistance, float cylindricalVertexDistance, float environmentalStart, float environmantalEnd, float renderDistanceStart, float renderDistanceEnd) {
	return max(linear_fog_value(sphericalVertexDistance, environmentalStart, environmantalEnd), linear_fog_value(cylindricalVertexDistance, renderDistanceStart, renderDistanceEnd));
}

vec4 apply_fog(vec4 inColor, float sphericalVertexDistance, float cylindricalVertexDistance, float environmentalStart, float environmantalEnd, float renderDistanceStart, float renderDistanceEnd, vec4 fogColor) {
	float fogValue = total_fog_value(sphericalVertexDistance, cylindricalVertexDistance, environmentalStart, environmantalEnd, renderDistanceStart, renderDistanceEnd);
	
	if(fogColor.r < 0.2 && fogColor.g < 0.2 && fogColor.b > 0.2){
		fogColor = vec4(fogColor.b,0,0,fogColor.a);
		
		//inColor.r += fogColor.r / 4;
		inColor.r *= (1 + fogColor.r * 10);
		inColor.g *= (1 + fogColor.r * 5);
		inColor.b /= (1 + fogColor.r * 10);
	}
	
	return vec4(mix(inColor.rgb, fogColor.rgb, fogValue * fogColor.a), inColor.a);
}

float fog_spherical_distance(vec3 pos) {
	return length(pos);
}

float fog_cylindrical_distance(vec3 pos) {
	float distXZ = length(pos.xz);
	float distY = abs(pos.y);
	return max(distXZ, distY);
}
