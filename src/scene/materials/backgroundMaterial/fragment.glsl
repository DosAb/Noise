precision lowp float;

uniform float uTime;
uniform float uMobile;
uniform vec2 uMouse;
uniform float uSpeed;
uniform vec2 uResolution;
uniform vec3 uColor;
uniform vec3 uSecondColor;
uniform vec3 uInnerColor;
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


#define layers 6 //int how many layers
#define speed .5 //float speed multiplyer
#define scale 1.2 //float scale multiplyer

vec2 rotateUV(vec2 uv, float rotation)
{
    float mid = 0.5;
    return vec2(
        cos(rotation) * (uv.x - mid) + sin(rotation) * (uv.y - mid) + mid,
        cos(rotation) * (uv.y - mid) - sin(rotation) * (uv.x - mid) + mid
    );
}

vec3 hash( vec3 p )
{
	p = vec3( dot(p,vec3(127.1,311.7, 74.7)),
			  dot(p,vec3(269.5,183.3,246.1)),
			  dot(p,vec3(113.5,271.9,124.6)));
	p = -1.0 + 2.0*fract(sin(p)*43758.5453123);

	return p;
}

float noise( in vec3 p )
{
    vec3 i = floor( p );
    vec3 f = fract( p );
	
	vec3 u = f*f*(3.0-2.0*f);

    return mix( mix( mix( dot( hash( i + vec3(0.0,0.0,0.0) ), f - vec3(0.0,0.0,0.0) ), 
                          dot( hash( i + vec3(1.0,0.0,0.0) ), f - vec3(1.0,0.0,0.0) ), u.x),
                     mix( dot( hash( i + vec3(0.0,1.0,0.0) ), f - vec3(0.0,1.0,0.0) ), 
                          dot( hash( i + vec3(1.0,1.0,0.0) ), f - vec3(1.0,1.0,0.0) ), u.x), u.y),
                mix( mix( dot( hash( i + vec3(0.0,0.0,1.0) ), f - vec3(0.0,0.0,1.0) ), 
                          dot( hash( i + vec3(1.0,0.0,1.0) ), f - vec3(1.0,0.0,1.0) ), u.x),
                     mix( dot( hash( i + vec3(0.0,1.0,1.0) ), f - vec3(0.0,1.0,1.0) ), 
                          dot( hash( i + vec3(1.0,1.0,1.0) ), f - vec3(1.0,1.0,1.0) ), u.x), u.y), u.z );
}



void main() {

    float strength = smoothstep(0.2, 0.5, (vUv.x * 3.0 - 1.0 - (uMouse.x * 0.5) + noise(vec3(vUv * 2.0, 1.0))));
    float strength2 = 1.0 - smoothstep(0.2, 0.5, (vUv.x * 3.0 - 2.5 + noise(vec3(vUv * 2.0, uTime * 0.2)) * 0.5));
    float removeTopStrength = 1.0 - smoothstep(0.2, 0.5, (vUv.y - ((1.0 - uMouse.y - 0.5) * 4.0 + 1.0) * 0.3 + noise(vec3(vec2(vUv.y * 2.0, vUv.x * 6.0 + 1.3), uTime * 0.4)) * 0.3));
    
    vec2 rotatedUvStr1 = rotateUV(vUv, 5.7);
    vec2 rotatedUvStr2 = rotateUV(vUv, 5.8);

    float mobileStrength = smoothstep(0.2, 0.5, (rotatedUvStr1.x * 3.0 - 0.8 + noise(vec3(rotatedUvStr1 * 2.0, 1.0))));
    float mobileStrength2 = 1.0 - smoothstep(0.2, 0.5, (rotatedUvStr2.x * 2.0 - 1.2 + noise(vec3(vec2(rotatedUvStr2.x * 2.0, rotatedUvStr2.y * 2.0 + 4.7), uSpeed)) * 0.5));

    vec2 uv2 = (gl_FragCoord.xy-uResolution.xy-.5)/uResolution.y;
    uv2.x *= 2.0;
    uv2.y *= 1.2;
    uv2.x += 1.;

    float t = (uTime * speed + uMouse.x) + 20.0;


    uv2 *= scale;
    float h = noise(vec3(uv2 * 2.0,t));
    //uv distortion loop 
    for (int n = 1; n < layers; n++){
        float i = float(n);
        uv2 -= vec2(0.6 / i * sin(i * uv2.y + i + t * 5.0 + h * i) + 0.8, 0.4 / i * sin(uv2.x + 4.0-i+h + t*5. + 0.3 * i) + 2.6);
    }

    uv2 -= vec2(1.2 * sin(uv2.x + t + h) + 1.8, 0.4 * sin(uv2.y + t + 0.3 * h) + 1.6);


    // Time varying pixel color
    vec3 col2 = vec3( sin(uv2.x) * 0.8 + 0.6 , 0.0, 0.0);
    if(uMobile == 1.0)
    {
        col2 *= mobileStrength;
        col2 *= mobileStrength2;
    }else{
        col2 *= strength;
        col2 *= strength2;
    }
    col2 *= removeTopStrength;

    float removeLayer = smoothstep(0.2, 0.4, col2.r);

    float outerLayer = clamp((col2.r), 0.0, 0.8) - removeLayer;
    outerLayer = smoothstep(0.0, 0.5, outerLayer);

    float newLayer = outerLayer;

    float innerLayer = smoothstep(1.2, 1.6, col2.r);

    vec4 noiseTexture = texture2D(uNoiseTexture, fract(vUv * 30.0 + uTime * 100.0));   
    float randomNoise = random(vec2((vUv.x + sin(uv2.y)) * .1, sin(uTime))) * 0.6 - 0.5 ;


    float mask = col2.r * 0.8;

    vec3 finalColor = mix(uSecondColor, uColor, mask);
    finalColor = mix(finalColor, uSecondColor, outerLayer);
    finalColor = mix(finalColor, uInnerColor, innerLayer);
    finalColor = mix(uBackgroundColor, finalColor, mask);

    float alpha = (sin(vUv.y * PI * 6.0)); // alpha = 1.;

    gl_FragColor = vec4(vec3(finalColor), 1.0 - randomNoise);
}