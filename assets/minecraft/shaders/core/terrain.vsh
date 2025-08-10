#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

vec4 minecraft_sample_lightmap(sampler2D lightMap, ivec2 uv) {
    return texture(lightMap, clamp(uv / 256.0, vec2(0.5 / 16.0), vec2(15.5 / 16.0)));
}

float rand(vec3 seed){
	return ((sin(seed.x) * cos(seed.z)) + 0.5) * 2;
}

void main() {
    vec3 pos = Position + ModelOffset;

    sphericalVertexDistance = fog_spherical_distance(pos);
    cylindricalVertexDistance = fog_cylindrical_distance(pos);
    vertexColor = Color;
	vec4 light = vec4(1,1,1,1);
	if(vertexColor.r < 0.5 && vertexColor.g < 0.5 && vertexColor.b > 0.5){
		vertexColor.r = vertexColor.g = vertexColor.b = 1;
		
		pos.y -= rand(pos) / 16;
	}else{
		light = minecraft_sample_lightmap(Sampler2, UV2);
		light *= light * light;
	}
	
	gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
	
	vertexColor *= light;
    texCoord0 = UV0;
}
