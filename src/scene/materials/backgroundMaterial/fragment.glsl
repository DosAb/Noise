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


#define PI 3.1415926

#define iterations 1
#define interationFpr 2

const float arrow_density = 1.5;
const float arrow_length = .45;

const vec3 luma = vec3(0.2126, 0.7152, 0.0722);

float f(in vec2 p)
{
    return sin(p.x+sin(p.y+uTime*0.1)) * sin(p.y*p.x*0.1+uTime*0.2);
}


//---------------Field to visualize defined here-----------------
vec2 field(in vec2 p)
{
	vec2 ep = vec2(.05,0.);
    vec2 rz= vec2(0);
	for( int i=0; i<7; i++ )
	{
		float t0 = f(p);
		float t1 = f(p + ep.xy);
		float t2 = f(p + ep.yx);
        vec2 g = vec2((t1-t0), (t2-t0))/ep.xx;
		vec2 t = vec2(-g.y,g.x);
        
        p += .9*t + g*0.3;
        rz= t;
	}
    
    return rz;
}

float segm(in vec2 p, in vec2 a, in vec2 b) //from iq
{
	vec2 pa = p - a;
	vec2 ba = b - a;
	float h = clamp(dot(pa,ba)/dot(ba,ba), 0., 1.);
	return length(pa - ba*h)*20. * arrow_density;
}



void main() {

    vec2 p = gl_FragCoord.xy / uResolution.xy-0.5;
	p.x *= uResolution.x/uResolution.y;
    p *= 6.;
	
    vec2 fld = field(p);
    vec3 col = sin(vec3(-.3,0.1,0.5)+fld.x-fld.y)*0.65+0.35;

    vec4 noiseTexture = texture2D(uNoiseTexture, fract(vUv * 30.0 + uTime * 100.0));   

	vec2 uv = gl_FragCoord.xy / uResolution.xy;
    uv.x *= 1.3;
    uv.x -= 0.35;
    uv.y *= 0.3;
    uv.y += 0.5;

	float res = 1.;
    for (int i = 0; i < iterations; i++) {
        res += cos(uv.y * 9.345 - uTime * 4.0 + cos(res * 1.234) * 0.2 + cos(uv.x * 20.2345 + cos(uv.y * 17.234)) ) + cos(uv.x*1.345);
    }

    float c = cos(res+cos(uv.y*24.3214)*.1+cos(uv.x*0.324+uTime*4.)+uTime)*.5+.5;
    c = 1.0 - clamp( (length(uv-.5 + cos(uTime+uv.yx * 0.34 + uv.xy * res) * 0.1 ) * 5.0 - 0.4) , 0.0, 1.0);



    gl_FragColor = vec4(vec3(col), 1.0 - noiseTexture.a);
    // gl_FragColor = vec4(vec3(col.g, col.g, col.g), 1.0 - noiseTexture.a);
}