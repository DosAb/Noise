export default /*glsl */

`
uniform float uTime;
varying vec2 vUv;

void main()
{
    vUv = uv;
    gl_Position = vec4(position, 0.5);
}
`