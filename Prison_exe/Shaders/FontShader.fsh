uniform sampler2D u_Texture;
uniform highp float u_MatSpecularIntensity;
uniform highp float u_Shininess;
uniform lowp vec4 u_MatColor;

struct Light {
    lowp vec3 Color;
    lowp float AmbientIntensity;
    lowp float DiffuseIntensity;
    lowp vec3 Direction;
};
uniform Light u_Light;

varying mediump vec2 frag_TexCoord;

void main()
{
    //gl_FragColor = texture2D(u_Texture, frag_TexCoord);
    gl_FragColor = vec4(1, 1, 1, texture2D(u_Texture, frag_TexCoord).r) * vec4(1, 1, 1, 1);
}
