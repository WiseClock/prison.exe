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
}
