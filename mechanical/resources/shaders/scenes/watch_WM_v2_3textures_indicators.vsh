#version 300 es

precision mediump float;

in vec3 aPosition;
in vec2 aTexCoord;
in vec3 aNormal;
in vec3 aTangent;

out vec2 vUV;
out vec3 vNormal;
out vec3 vTangent;
out vec3 vBitangent;
out vec3 vViewVec;

uniform mat4 uCubeMatrix;
uniform vec3 uSize;

uniform highp mat4 uMvpMatrix;
uniform highp mat4 uViewMatrix;
uniform mat4 uModelView;
uniform mat3 uNormalMatrix;

void main()
{
  vec4 vPosition = vec4( aPosition, 1.0);

  highp vec4 mPosition = uMvpMatrix * vPosition;
  /*highp mat4 nCubeMatrix = uViewMatrix * uCubeMatrix;

  //6.0 is the camera distance from origin
  highp vec4 rPosition;
  rPosition.x = mPosition.x + (6.0-mPosition.z) * nCubeMatrix[2].x;
  rPosition.y = mPosition.y + (6.0-mPosition.z) * nCubeMatrix[2].y;
  rPosition.z = mPosition.z;
  rPosition.w = mPosition.w;*/

  gl_Position = mPosition;

  vUV = aTexCoord;

  vNormal = normalize(uNormalMatrix * aNormal);

  vTangent = normalize(uNormalMatrix * aTangent);

  vBitangent = cross(vNormal, vTangent);

  vViewVec = (uModelView * vPosition).xyz;
}
