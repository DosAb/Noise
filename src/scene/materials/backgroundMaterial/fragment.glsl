precision lowp float;

uniform float uTime;
uniform vec2 uResolution;
uniform vec3 uColor;
uniform vec3 uSecondColor;
uniform vec3 uBackgroundColor;
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

#define PI 3.1415926
#define s(a) sin(a)
#define c(a) cos(a)
#define t uTime 

#define iterations 1
#define interationFpr 2


void main() {
    // vec2 uv = vUv;

    // vec2 p=(2.0*gl_FragCoord.xy-uResolution.xy)/max(uResolution.x,uResolution.y);
	// for(int i=1;i<10;i++)
	// {
	// 	vec2 newp=p;
	// 	newp.x+=0.6 / float(i) * sin(float(i) * p.y + uTime + 0.3 * float(i)) + 1.0;
	// 	newp.y+=0.6 / float(i) * sin(float(i) * p.x + uTime + 0.3 * float(i+10)) - 1.4;
	// 	p=newp;
	// }
	// vec3 col=vec3(1.0,1.0-(sin(p.y)),sin(p.x+p.y));


    // float x = uv.x;
    // float y = uv.y * 0.5;
    // float firstCalc = x * PI * 2.0 + y * PI * sin(cos(t * 0.7 - y) + sin(y - t * 0.2) * 12.0) * 0.3 - PI / 1.0;
    // float f = (sin(firstCalc) - y) * (y * PI + 0.3);

    // float strength = sin(vUv.x * 10.0);

    vec4 noiseTexture = texture2D(uNoiseTexture, fract(vUv * 30.0 + uTime * 100.0));   
    // vec3 color = vec3(f * 0.,f * 1.0, f * 0.5 - y * sin(x * PI * 2.0 + t));
    // color = color * col;
	vec2 uv = gl_FragCoord.xy / uResolution.xy;
    uv.x *= 1.3;
    uv.x -= 0.35;
    uv.y *= 0.3;
    uv.y += 0.5;

	float res = 1.;
    for (int i = 0; i < iterations; i++) {
        res += cos(uv.y * 9.345 - uTime * 4.0 + cos(res * 1.234) * 0.2 + cos(uv.x * 20.2345 + cos(uv.y * 17.234)) ) + cos(uv.x*1.345);
    }
    vec3 c = mix(vec3(1.,0.,0.),
                 vec3(.6,.2,.2),
                 cos(res+cos(uv.y*24.3214)*.1+cos(uv.x*0.324+uTime*4.)+uTime)*.5+.5);
    
    c = mix(c,
            vec3(0.),
            clamp( (length(uv-.5 + cos(uTime+uv.yx * 0.34 + uv.xy * res) * 0.1 ) * 5.0 - 0.4) , 0.0, 1.0));


	float res2 = 1.;
    for (int i = 0; i < interationFpr; i++) {
        res2 += cos(uv.y * 9.345 - uTime * 2.0 + cos(res * 1.234) * 0.2 + cos(uv.x * 10.2345 + cos(uv.y * 20.234)) ) + cos(uv.x * 1.345);
    }
        

	vec3 c2 = mix(vec3(1.,0.,0.),
                 vec3(.6,.2,.2),
                 cos(res2+cos(uv.y * 2.3214) * 1.1 + cos( uv.x * 0.324 + uTime*4.) +uTime) * 0.2 + .8);
    
    c2 = mix(c2,
            vec3(0.),
            clamp( (length(uv-.5 + cos(uTime+uv.yx * 0.34+uv.xy*res2)*.1 )*5.-.4) , 0., 1.));

    vec3 finalColor = mix(vec3(uBackgroundColor), uColor, c.r * 1.5);
    finalColor = mix(finalColor, uSecondColor, c2.r);


    gl_FragColor = vec4(vec3(finalColor), 1.0 - noiseTexture.a);
    // gl_FragColor = vec4(vec3(col.g, col.g, col.g), 1.0 - noiseTexture.a);
}