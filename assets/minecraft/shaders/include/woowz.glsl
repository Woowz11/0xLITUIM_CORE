#version 150

float rand(vec3 seed){
	return (fract(sin(dot(seed, vec3(12.9898, 78.233, 151.7182))) * 43758.5453) - 0.5) * 2;
}

float sincos(vec3 seed){
	return ((sin(seed.x) * cos(seed.z)) + 0.5) * 2;
}

vec3 overlay(vec3 sample, vec3 color) {
	vec3 result;
	for (int i = 0; i < 3; i++) {
		result[i] = sample[i] < 0.5 ? (2.0 * sample[i] * color[i]) : (1.0 - 2.0 * (1.0 - sample[i]) * (1.0 - color[i]));
	}
	return result;
}