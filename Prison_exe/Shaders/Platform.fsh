varying lowp vec4 frag_Color;
varying lowp vec2 frag_TexCoord;
varying lowp vec3 frag_Normal;
varying lowp vec3 frag_Position;

uniform sampler2D u_Texture;
uniform highp float u_MatSpecularIntensity;
uniform highp float u_Shininess;
uniform lowp vec4 u_MatColor;
uniform highp float u_Time;
uniform highp float u_Fog;

struct Light {
    lowp vec3 Color;
    lowp float AmbientIntensity;
    lowp float DiffuseIntensity;
    lowp vec3 Direction;
};
uniform Light u_Light;

lowp float makePoint(lowp float x, lowp float y, lowp float fx, lowp float fy, lowp float sx, lowp float sy, lowp float t)
{
    t = t / 6.0;
    lowp float xx=x+sin(t*fx)*sx;
    lowp float yy=y+cos(t*fy)*sy;
    return 1.0/sqrt(xx*xx+yy*yy);
}

void main(void) {
    // Ambient
    lowp vec3 AmbientColor = u_Light.Color * u_Light.AmbientIntensity;
    
    // Diffuse
    lowp vec3 Normal = normalize(frag_Normal);
    lowp float DiffuseFactor = max(-dot(Normal, u_Light.Direction), 0.0);
    lowp vec3 DiffuseColor = u_Light.Color * u_Light.DiffuseIntensity * DiffuseFactor;
    
    // Specular
    lowp vec3 Eye = normalize(frag_Position);
    lowp vec3 Reflection = reflect(u_Light.Direction, Normal);
    lowp float SpecularFactor = pow(max(0.0, -dot(Reflection, Eye)), u_Shininess);
    lowp vec3 SpecularColor = u_Light.Color * u_MatSpecularIntensity * SpecularFactor;
    
    //lowp vec2 p = (vec2(64, 64) / 1.5) * 2.0 - vec2(0.5, 0.5);
    lowp vec2 p = (frag_TexCoord.xy) - vec2(0.5, 0.5);
    
    p = p / 10.0;
    
    lowp float x = p.x;
    lowp float y = p.y;
    
    lowp float a =
    makePoint(x,y,3.3,2.9,0.3,0.3,u_Time);
    //a=a+makePoint(x,y,1.9,2.0,0.4,0.4,u_Time);
    //a=a+makePoint(x,y,0.8,0.7,0.4,0.5,u_Time);
    //a=a+makePoint(x,y,2.3,0.1,0.6,0.3,u_Time);
    //a=a+makePoint(x,y,0.8,1.7,0.5,0.4,u_Time);
    //a=a+makePoint(x,y,0.3,1.0,0.4,0.4,u_Time);
    //a=a+makePoint(x,y,1.4,1.7,0.4,0.5,u_Time);
    //a=a+makePoint(x,y,1.3,2.1,0.6,0.3,u_Time);
    //a=a+makePoint(x,y,1.8,1.7,0.5,0.4,u_Time);
    
    lowp float b =
    makePoint(x,y,1.2,1.9,0.3,0.3,u_Time);
    //b=b+makePoint(x,y,0.7,2.7,0.4,0.4,u_Time);
    //b=b+makePoint(x,y,1.4,0.6,0.4,0.5,u_Time);
    //b=b+makePoint(x,y,2.6,0.4,0.6,0.3,u_Time);
    //b=b+makePoint(x,y,0.7,1.4,0.5,0.4,u_Time);
    //b=b+makePoint(x,y,0.7,1.7,0.4,0.4,u_Time);
    //b=b+makePoint(x,y,0.8,0.5,0.4,0.5,u_Time);
    //b=b+makePoint(x,y,1.4,0.9,0.6,0.3,u_Time);
    //b=b+makePoint(x,y,0.7,1.3,0.5,0.4,u_Time);
    
    lowp float c =
    makePoint(x,y,3.7,0.3,0.3,0.3,u_Time);
    //c=c+makePoint(x,y,1.9,1.3,0.4,0.4,u_Time);
    //c=c+makePoint(x,y,0.8,0.9,0.4,0.5,u_Time);
    //c=c+makePoint(x,y,1.2,1.7,0.6,0.3,u_Time);
    //c=c+makePoint(x,y,0.3,0.6,0.5,0.4,u_Time);
    //c=c+makePoint(x,y,0.3,0.3,0.4,0.4,u_Time);
    //c=c+makePoint(x,y,1.4,0.8,0.4,0.5,u_Time);
    //c=c+makePoint(x,y,0.2,0.6,0.6,0.3,u_Time);
    //c=c+makePoint(x,y,1.3,0.5,0.5,0.4,u_Time);
    
    lowp vec3 d = vec3(a, b, c) / 5.0;
    
    gl_FragColor = u_MatColor * texture2D(u_Texture, frag_TexCoord) * vec4(d, 1.0) * vec4((AmbientColor + DiffuseColor + SpecularColor), 1.0);
    
    if (u_Fog > 0.0)
    {
        const highp float LOG2 = 1.442695;
        highp float z = gl_FragCoord.z / gl_FragCoord.w;
        highp float fogFactor = exp2( -0.01 * 0.01 * z * z * LOG2 );
        fogFactor = clamp(fogFactor, 0.0, 1.0);
        gl_FragColor = mix(vec4(1.0, 0.2, 0.2, 1.0), gl_FragColor, fogFactor );
    }
    // gl_FragColor = vec4(d.x,d.y,d.z,0.5);
}

