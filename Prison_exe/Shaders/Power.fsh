precision mediump float;

varying lowp vec4 frag_Color;
varying lowp vec2 frag_TexCoord;
varying lowp vec3 frag_Normal;
varying lowp vec3 frag_Position;

uniform sampler2D u_Texture;
uniform highp float u_MatSpecularIntensity;
uniform highp float u_Shininess;
uniform lowp vec4 u_MatColor;
uniform highp float u_PowerTime;
uniform highp float u_Fog;

struct Light {
    lowp vec3 Color;
    lowp float AmbientIntensity;
    lowp float DiffuseIntensity;
    lowp vec3 Direction;
};
uniform Light u_Light;

void main(void)
{
    if (u_PowerTime < 0.01)
        gl_FragColor = vec4(0, 0, 0, 0);
    else if (frag_TexCoord.y > u_PowerTime)
        gl_FragColor = texture2D(u_Texture, frag_TexCoord) * vec4(1, 1, 1, 0.25);
    else
        gl_FragColor = texture2D(u_Texture, frag_TexCoord);
    
    if (u_Fog > 0.0)
    {
        const highp float LOG2 = 1.442695;
        highp float z = gl_FragCoord.z / gl_FragCoord.w;
        highp float fogFactor = exp2( -0.01 * 0.01 * z * z * LOG2 );
        fogFactor = clamp(fogFactor, 0.0, 1.0);
        gl_FragColor = mix(vec4(1.0, 0.2, 0.2, 1.0), gl_FragColor, fogFactor );
    }
}
