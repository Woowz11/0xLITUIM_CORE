#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:matrix.glsl>
#moj_import <minecraft:globals.glsl>

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;

in vec4 texProj0;
in float sphericalVertexDistance;
in float cylindricalVertexDistance;

const int LAYERS = 3;
const mat4 SCALE_TRANSLATE = mat4(
	0.5, 0.0, 0.0, 0.25,
	0.0, 0.5, 0.0, 0.25,
	0.0, 0.0, 1.0, 0.0,
	0.0, 0.0, 0.0, 1.0
);

mat2 rotate_z(float angle) {
	float c = cos(angle);
	float s = sin(angle);
	return mat2(c, -s, s, c);
}

float chaoticWave(float t) { return sin(t*17.0) * cos(t*31.0) + tan(t*13.0)*0.3 + pow(sin(t*7.0), 3.0); }

mat4 end_portal_layer(int layer, float time) {
	float depth = float(layer);

	float baseSpeed = 20.0;

	float angleZ = chaoticWave(time * baseSpeed + depth * 2.3) * 6.2831 * 20.0;
	float angleY = chaoticWave(time * (baseSpeed - 5.0) + depth * 1.7) * 6.2831 * 15.0;
	float angleX = chaoticWave(time * (baseSpeed - 8.0) + depth * 0.9) * 6.2831 * 10.0;

	mat2 rotZ = rotate_z(angleZ);

	float offsetX = chaoticWave(time * depth * 10.0) * 0.7;
	float offsetY = chaoticWave(time * depth * 12.0 + 10.0) * 0.7;

	vec3 offset = vec3(17.0 / depth + offsetX, (2.0 + depth / 1.5) * time * 40.0 + offsetY, 0.0);
	mat4 translate = mat4(
		1.0, 0.0, 0.0, offset.x,
		0.0, 1.0, 0.0, offset.y,
		0.0, 0.0, 1.0, offset.z,
		0.0, 0.0, 0.0, 1.0
	);

	float scale = 4.5 - depth / 4.0 + sin(time * 120.0 + depth) * 0.5 + chaoticWave(time * depth * 8.0) * 0.3;

	mat4 scaleRot = mat4(
		rotZ[0][0] * scale, rotZ[0][1] * scale, 0.0, 0.0,
		rotZ[1][0] * scale, rotZ[1][1] * scale, 0.0, 0.0,
		0.0, 0.0, 1.0, 0.0,
		0.0, 0.0, 0.0, 1.0
	);

	return translate * scaleRot * SCALE_TRANSLATE;
}

vec3 chromaticAberration(sampler2D tex, vec4 projCoord, float shift) {
	vec2 uv = projCoord.xy / projCoord.w;
	vec3 col = texture(tex, uv + vec2(shift, 0)).rgb;
	return col;
}

vec3 overlay(vec3 sample, vec3 color) {
    vec3 result;
    for (int i = 0; i < 3; i++) {
        result[i] = sample[i] < 0.5 ? (2.0 * sample[i] * color[i]) : (1.0 - 2.0 * (1.0 - sample[i]) * (1.0 - color[i]));
    }
    return result;
}

out vec4 fragColor;

void main() {
	vec3 color = vec3(1);

	for (int i = 1; i <= LAYERS; i++) {
		mat4 layerMat = end_portal_layer(i, GameTime * 0.0001);
		vec3 sample = chromaticAberration(Sampler1, texProj0 * layerMat, 0.002 * float(i));
		color = overlay(sample, color);
	}

	fragColor = apply_fog(vec4(color, 1.0), sphericalVertexDistance, cylindricalVertexDistance,
		FogEnvironmentalStart, FogEnvironmentalEnd,
		FogRenderDistanceStart, FogRenderDistanceEnd,
		FogColor);
}