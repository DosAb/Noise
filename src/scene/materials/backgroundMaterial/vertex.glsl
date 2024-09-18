uniform float uTime;
uniform vec2 uMouse;

varying vec2 vUv;


void main()
{
    vUv = uv;
    gl_Position = vec4(position, 0.5);
}