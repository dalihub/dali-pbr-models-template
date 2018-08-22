#version 300 es

precision mediump float;

in vec3 aPosition;
in vec2 aTexCoord;

out vec2 vUV;

uniform vec3 uSize;
uniform mat4 uMvpMatrix;

void main()
{

  vec4 vPosition = vec4( aPosition * uSize, 1.0 );
  gl_Position = uMvpMatrix * vPosition;

  vUV = aTexCoord;
}
