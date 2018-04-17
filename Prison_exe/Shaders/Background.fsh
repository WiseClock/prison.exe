precision mediump float;

varying lowp vec4 frag_Color;
varying lowp vec2 frag_TexCoord;
varying lowp vec3 frag_Normal;
varying lowp vec3 frag_Position;

uniform sampler2D u_Texture;
uniform highp float u_MatSpecularIntensity;
uniform highp float u_Shininess;
uniform lowp vec4 u_MatColor;
uniform highp float u_Time;

struct Light {
    lowp vec3 Color;
    lowp float AmbientIntensity;
    lowp float DiffuseIntensity;
    lowp vec3 Direction;
};
uniform Light u_Light;

#define u_Time (u_Time*1000.0)

void main(void)
{
    float bpm = 4.935;
    
    vec2 uv = frag_TexCoord + vec2(0.0, -0.2);
    uv = 53.5 * uv.xy;
    uv.x -= 12. * ((sin(abs(sin(u_Time/1.) * 5.) * uv.y * 50.) + 15.) / 15.);
    
    vec2 pos = vec2(15.)-uv;
    float r = length(pos)*2.0;
    float a = atan(pos.y,pos.x);
    
    //float f = 2.;
    //vec3 ring1 = vec3(1.-smoothstep(f,f+0.1,r) - (1.-smoothstep(f-0.1,f,r)));
    //f = 6.-ceil(abs(pow(cos(a),2.)*2.)*2.);
    //vec3 ring2 = vec3(1.-smoothstep(f,f+0.2,r) - (1.-smoothstep(f-0.2,f,r)));
    float f = 6.+ceil(abs(pow(cos(a),2.)*2.)*2.);
    vec3 ring3 = vec3(1.-smoothstep(f,f+.3,r) - (1.-smoothstep(f-.3,f,r)));
    //f = 7.+ceil(abs(pow(cos(a),2.)*2.)*2.) + abs(tan(a));
    //vec3 ring4 = vec3(1.-smoothstep(f,f+.4,r) - (1.-smoothstep(f-.4,f,r)));
    f = 8.+ceil(abs(pow(cos(a),2.)*2.)*2.) + abs(tan(a)) + abs(tan(a+3.1459/2.));
    vec3 ring5 = vec3(1.-smoothstep(f,f+.5,r) - (1.-smoothstep(f-.5,f,r)));
    //f = 8.-ceil(abs(cos(a)*2.)*2.)+min(ceil(abs(tan(a)*0.3)),6.);
    //vec3 ring6 = vec3(1.-smoothstep(f,f+.6,r) - (1.-smoothstep(f-.6,f,r)));
    f = 10.+ceil(abs(pow(cos(a),2.)*2.)*2.)+abs(tan(a))+abs(tan(a+3.1459/2.))+abs(tan(a*8.));
    vec3 ring7 = vec3(1.-smoothstep(f,f+3.25,r) - (1.-smoothstep(f-3.25,f,r)));
    
    vec3 color = /*ring1 + ring2 + ring3 + ring4 + ring5 + ring6 +*/ring3 + ring5 + ring7;
    color *= vec3(abs(sin(u_Time * bpm + r/(20.))) * 2., abs(cos(u_Time/2. + r)), abs(log(sin(u_Time + r))));
    color = pow(color, vec3(abs(sin(u_Time * bpm))) * 5.);
    gl_FragColor = vec4(color, 1.0);
    
    //gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}
