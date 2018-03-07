#version 300 es

precision mediump float;

in vec3 aPosition;
uniform vec3 uSize;
uniform mat4 uCubeMatrix;

uniform highp mat4 uMvpMatrix;
uniform highp mat4 uViewMatrix;

void main()
{
  vec4 vPosition = vec4( aPosition, 1.0);

  highp vec4 mPosition = uMvpMatrix * vPosition;
  highp mat4 nCubeMatrix = uViewMatrix * uCubeMatrix;

  //6.0 is the camera distance from origin
  highp vec4 rPosition;
  rPosition.x = mPosition.x + (6.0-mPosition.z) * nCubeMatrix[2].x;
  rPosition.y = mPosition.y + (6.0-mPosition.z) * nCubeMatrix[2].y;
  rPosition.z = mPosition.z;
  rPosition.w = mPosition.w;

  gl_Position = rPosition;
}
