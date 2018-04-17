uniform highp mat4 u_ModelViewMatrix;
uniform highp mat4 u_ProjectionMatrix;

attribute vec4 a_Position;
attribute vec4 a_Color;
attribute vec2 a_TexCoord;
attribute vec3 a_Normal;

varying mediump vec2 frag_TexCoord;

void main()
{
    //frag_TexCoord = vec2(a_TexCoord.x + 0.0, a_TexCoord.y + 0.01375);
    frag_TexCoord = a_TexCoord;
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * a_Position;
}
