//
//  QuadPowers.swift
//  Prison_exe
//
//  Created by Carl Kuang on 2018-04-16.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

class QuadPowers : Node
{
    let vertexList : [Vertex] = [
        // Front x,y,z,r,g,b,a,u,v,nx,ny,nz
        Vertex( 0.5, -0.5, 0.5,  1, 0, 0, 1,  1, 0,  0, 0, 1), // 0
        Vertex( 0.5,  0.5, 0.5,  0, 1, 0, 1,  1, 1,  0, 0, 1), // 1
        Vertex(-0.5,  0.5, 0.5,  0, 0, 1, 1,  0, 1,  0, 0, 1), // 2
        Vertex(-0.5, -0.5, 0.5,  0, 0, 0, 1,  0, 0,  0, 0, 1), // 3
    ]
    
    let indexList : [GLuint] = [
        // Front
        0, 1, 2,
        2, 3, 0,
        ]
    
    init(shader: ShaderProgram)
    {
        super.init(name: "quad", shaderProgram: shader, vertices: vertexList, indices: indexList)
        self.loadTexture("dungeon_01.png")
    }
    
    func setTexture(_ texture: String)
    {
        self.loadTexture(texture)
    }
    
    override func drawContent()
    {
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_INT), nil)
    }
}

