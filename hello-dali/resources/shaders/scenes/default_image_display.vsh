#version 300 es

in vec3 aPosition;
in vec2 aTexCoord;

out vec2 vUV;
out vec3 vNormal;
out vec3 vTangent;
out vec3 vBitangent;
out vec3 vViewVec;

uniform vec3 uSize;

uniform mat4 uCubeMatrix;

uniform mat4 uMvpMatrix;
uniform mat3 uNormalMatrix;
uniform mat4 uProjection;
uniform mat4 uModelMatrix;
uniform mat4 uModelView;
uniform mat4 uViewMatrix;

uniform vec2 uTilt;

void main()
{
  vec4 vPosition = vec4( aPosition * uSize, 1.0);
  vec4 mPosition = uModelMatrix * vPosition;

  //mPosition.xy += mPosition.z * uCubeMatrix[2].xy;
  mPosition.xy += 0.3 * uTilt * mPosition.z;
  gl_Position = uProjection * uViewMatrix * mPosition;

  vUV = aTexCoord;

}
