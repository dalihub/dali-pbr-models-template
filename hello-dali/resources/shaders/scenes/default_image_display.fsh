#version 300 es

precision highp float;

uniform sampler2D sAlbedo;


in vec2 vUV;
in vec3 vNormal;
in vec3 vTangent;
in vec3 vBitangent;
in vec3 vViewVec;

out vec4 FragColor;

void main()
{
  FragColor = texture(sAlbedo, vUV.st);
}
