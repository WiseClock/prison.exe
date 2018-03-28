uniform highp mat4 view;
uniform highp mat4 projection;

attribute vec3 a_pos;
attribute vec3 a_col;

varying lowp vec3 o_color;

void main(void) {
    
    o_color = a_col;
    
    gl_Position = projection * view * vec4(a_pos, 1.0);
}
