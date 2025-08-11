#version 150

layout(std140) uniform DynamicTransforms {
	mat4 ModelViewMat;
	vec4 ColorModulator;
	vec3 ModelOffset;
	mat4 TextureMat;
	float LineWidth;
};

layout(std140) uniform Globals {
    vec2 ScreenSize;
    float GlintAlpha;
    float GameTime;
    int MenuBlurRadius;
};

uniform sampler2D Sampler0;

in vec2 texCoord0;
in vec4 vertexColor;

out vec4 fragColor;

float rand(vec3 seed){
	return (fract(sin(dot(seed, vec3(12.9898, 78.233, 151.7182))) * 43758.5453) - 0.5) * 2;
}

void main() {
	vec4 color = texture(Sampler0, texCoord0) * vertexColor;
	if (color.a == 0.0) { discard; }
	
	if(color.r == 1 && color.g == 1 && color.b == 1){
		float rnd = rand(gl_FragCoord.xyz + vec3(GameTime,GameTime,GameTime)) * 5;
		rnd = min(rnd, 1);
		color.r = color.g = color.b = rnd;
	}
	
	fragColor = color * ColorModulator;
}
