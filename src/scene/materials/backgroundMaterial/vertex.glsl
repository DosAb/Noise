varying vec2 vUv;
uniform float uTime;


void main()
{
  vUv = uv;

  gl_Position = vec4(position, 0.5);
}