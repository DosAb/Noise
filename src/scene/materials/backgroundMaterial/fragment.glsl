precision lowp float;

uniform float uTime;
uniform vec2 uResolution;
uniform vec3 uColor;
uniform sampler2D uNoiseTexture;
varying vec2 vUv;

mat2 m(float a){float c=cos(a), s=sin(a);return mat2(c,-s,s,c);}
float map(vec3 p){
    p.xz*= m(uTime*0.4);p.xy*= m(uTime*0.3);
    vec3 q = p*2.+uTime;
    return length(p+vec3(sin(uTime*0.7)))*log(length(p)+1.) + sin(q.x+sin(q.z+sin(q.y)))*0.5 - 1.;
}

float random(vec2 st)
{
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}


vec2 rotateUV(vec2 uv, float rotation)
{
    float mid = 0.5;
    return vec2(
        cos(rotation) * (uv.x - mid) + sin(rotation) * (uv.y - mid) + mid,
        cos(rotation) * (uv.y - mid) - sin(rotation) * (uv.x - mid) + mid
    );
}



void main() {
    vec2 uv = vUv;
    // vec2 p = gl_FragCoord.xy/uResolution.y - vec2(.9,.5);

    float mr = min(uResolution.x, uResolution.y);
    vec2 uv2 = (gl_FragCoord.xy * 2.0 - uResolution.xy) / mr;

    float d2 = -uTime * 0.5;
    float a = 0.0;
    for (float i = 0.0; i < 8.0; ++i) {
        a += cos(i - d2 - a * uv2.x);
        d2 += sin(uv2.y * i + a);
    }
    d2 += uTime * 0.5;
    vec3 color = vec3(cos(uv2 * vec2(d2, a)) * 0.6 + 0.4, cos(a + d2) * 0.5 + 0.5);
    color = cos(color * cos(vec3(d2, a, 2.5)) * 0.5 + 0.5);


    vec4 noiseTexture = texture2D(uNoiseTexture, fract(uv * 30.0 + uTime * 100.0));    

    gl_FragColor = vec4(vec3(color), 1.0 - noiseTexture.a);
    // gl_FragColor = vec4(vec3(col.g, col.g, col.g), 1.0 - noiseTexture.a);
}