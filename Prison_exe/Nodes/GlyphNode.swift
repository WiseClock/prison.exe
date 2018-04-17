//
//  GlyphNode.swift
//  Prison_exe
//
//  Created by Carl Kuang on 2018-04-12.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

class GlyphNode : Node
{
    let shader : ShaderProgram
    let vertexList : [Vertex]
    let indexList : [GLuint] = [
        // Front
        0, 1, 2,
        2, 3, 0,
        ]
    let solid : Bool
    
    init(shader: ShaderProgram, texture: String, width: Float, height: Float, startX: Float, startY: Float, endX: Float, endY: Float, forceSolid: Bool = false)
    {
        self.shader = shader
        self.solid = forceSolid
        
        vertexList = [
            // Front x,y,z,r,g,b,a,u,v,nx,ny,nz
            Vertex( width, 0, 0.001,  1, 0, 0, 1,  endX, startY,  0, 0, 1), // 0
            Vertex( width,  height, 0.001,  0, 1, 0, 1,  endX, endY,  0, 0, 1), // 1
            Vertex(0,  height, 0.001,  0, 0, 1, 1,  startX, endY,  0, 0, 1), // 2
            Vertex(0, 0, 0.001,  0, 0, 0, 1,  startX, startY,  0, 0, 1), // 3
        ]
        
        super.init(name: "glyph", shaderProgram: shader, vertices: vertexList, indices: indexList)
        self.loadTexture(texture)
    }
    
    override func drawContent()
    {
        glUseProgram(shader.programHandle)
        glUniform1f(glGetUniformLocation(shader.programHandle, "u_ForceSolid"), GLfloat(self.solid ? 1 : 0))
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_INT), nil)
    }
}

