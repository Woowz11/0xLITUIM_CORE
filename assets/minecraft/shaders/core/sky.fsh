#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:woowz.glsl>

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec3 pos;

out vec4 fragColor;

float mandelbrot(vec2 c) {
    vec2 z = vec2(0.0);
    float n = 0.0;
    for (int i = 0; i < 100; i++) {
        z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;
        if (dot(z, z) > 4.0) {
            break;
        }
        n += 1.0;
    }
    return n / 100.0;
}

vec2 rotate(vec2 v, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    mat2 m = mat2(c, -s, s, c);
    return m * v;
}

void main() {
    vec2 uv = gl_FragCoord.xy / ScreenSize * 2.0 - 1.0;
    
    vec2 offset = vec2(sin(pos.x), cos(pos.z)) * 0.5;
    uv = rotate(uv, pos.y + pos.z * pos.x);
    
    vec3 color = vec3(0);
    for (int i = 0; i < 5; i++) {
        vec2 c = uv + offset + vec2(sin(pos.x + float(i) * 2.0), cos(pos.y + float(i) * 2.0)) * 0.5;
        float fractalValue = mandelbrot(c);
        
        color += vec3(fractalValue * rand(gl_FragCoord.xyz), 0, 0);
    }
	
    fragColor = apply_fog(
        vec4(color, 1),
        sphericalVertexDistance,
        cylindricalVertexDistance,
        0,
        FogSkyEnd,
        FogSkyEnd,
        FogSkyEnd,
        FogColor
    );
}