#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:woowz.glsl>

in vec3 Position;

out vec4 texProj0;
out float sphericalVertexDistance;
out float cylindricalVertexDistance;

void main() {
	gl_Position = ProjMat * ModelViewMat * vec4(Position.x, Position.y - sincos(Position * 10) / 15, Position.z, 1.0);

	texProj0 = projection_from_position(gl_Position);
	sphericalVertexDistance   = fog_spherical_distance(Position);
	cylindricalVertexDistance = fog_cylindrical_distance(Position);
}