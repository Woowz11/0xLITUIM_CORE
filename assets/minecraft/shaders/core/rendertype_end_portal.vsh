#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>

in vec3 Position;

out vec4 texProj0;
out float sphericalVertexDistance;
out float cylindricalVertexDistance;

float rand(vec3 seed){
	return (fract(sin(dot(seed, vec3(12.9898, 78.233, 151.7182))) * 43758.5453) - 0.5) * 2;
}

void main() {
    vec3 displacedPosition = Position;
	displacedPosition.y += rand(Position + vec3(0.0, 1.0, 0.0)) / 30;

    gl_Position = ProjMat * ModelViewMat * vec4(displacedPosition, 1.0);

    texProj0 = projection_from_position(gl_Position);
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
}