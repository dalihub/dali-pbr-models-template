#version 300 es

precision mediump float;

uniform sampler2D sShadow;

uniform mat4 uCubeMatrix;

in vec2 vUV;

out vec4 FragColor;

void main()
{
  FragColor = texture( sShadow, vUV.st );
}
