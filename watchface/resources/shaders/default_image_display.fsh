#version 300 es

precision mediump float;

uniform sampler2D sAlbedo;

in vec2 vUV;

out vec4 FragColor;

void main()
{
  FragColor = texture( sAlbedo, vUV.st );
}
