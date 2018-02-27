//
//  Cube.swift
//
//  Created by Ryan Dieno on 2018-02-02.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

class Cube : Node {
    
    let vertexList : [Vertex] = [
        
        // Front x,y,z,r,g,b,a,u,v,nx,ny,nz
        Vertex( 0.5, -0.5, 0.5,  1, 0, 0, 1,  1, 0,  0, 0, 1), // 0
        Vertex( 0.5,  0.5, 0.5,  0, 1, 0, 1,  1, 1,  0, 0, 1), // 1
        Vertex(-0.5,  0.5, 0.5,  0, 0, 1, 1,  0, 1,  0, 0, 1), // 2
        Vertex(-0.5, -0.5, 0.5,  0, 0, 0, 1,  0, 0,  0, 0, 1), // 3
        
        // Back
        Vertex(-0.5, -0.5, -0.5, 0, 0, 1, 1,  1, 0,  0, 0,-1), // 4
        Vertex(-0.5,  0.5, -0.5, 0, 1, 0, 1,  1, 1,  0, 0,-1), // 5
        Vertex( 0.5,  0.5, -0.5, 1, 0, 0, 1,  0, 1,  0, 0,-1), // 6
        Vertex( 0.5, -0.5, -0.5, 0, 0, 0, 1,  0, 0,  0, 0,-1), // 7
        
        // Left
        Vertex(-0.5, -0.5,  0.5, 1, 0, 0, 1,  1, 0, -1, 0, 0), // 8
        Vertex(-0.5,  0.5,  0.5, 0, 1, 0, 1,  1, 1, -1, 0, 0), // 9
        Vertex(-0.5,  0.5, -0.5, 0, 0, 1, 1,  0, 1, -1, 0, 0), // 10
        Vertex(-0.5, -0.5, -0.5, 0, 0, 0, 1,  0, 0, -1, 0, 0), // 11
        
        // Right
        Vertex( 0.5, -0.5, -0.5, 1, 0, 0, 1,  1, 0,  1, 0, 0), // 12
        Vertex( 0.5,  0.5, -0.5, 0, 1, 0, 1,  1, 1,  1, 0, 0), // 13
        Vertex( 0.5,  0.5,  0.5, 0, 0, 1, 1,  0, 1,  1, 0, 0), // 14
        Vertex( 0.5, -0.5,  0.5, 0, 0, 0, 1,  0, 0,  1, 0, 0), // 15
        
        // Top
        Vertex( 0.5,  0.5,  0.5, 1, 0, 0, 1,  1, 0,  0, 1, 0), // 16
        Vertex( 0.5,  0.5, -0.5, 0, 1, 0, 1,  1, 1,  0, 1, 0), // 17
        Vertex(-0.5,  0.5, -0.5, 0, 0, 1, 1,  0, 1,  0, 1, 0), // 18
        Vertex(-0.5,  0.5,  0.5, 0, 0, 0, 1,  0, 0,  0, 1, 0), // 19
        
        // Bottom
        Vertex( 0.5, -0.5, -0.5, 1, 0, 0, 1,  1, 0,  0,-1, 0), // 20
        Vertex( 0.5, -0.5,  0.5, 0, 1, 0, 1,  1, 1,  0,-1, 0), // 21
        Vertex(-0.5, -0.5,  0.5, 0, 0, 1, 1,  0, 1,  0,-1, 0), // 22
        Vertex(-0.5, -0.5, -0.5, 0, 0, 0, 1,  0, 0,  0,-1, 0), // 23
        
    ]
    
    let indexList : [GLuint] = [
        
        // Front
        0, 1, 2,
        2, 3, 0,
        
        // Back
        4, 5, 6,
        6, 7, 4,
        
        // Left
        8, 9, 10,
        10, 11, 8,
        
        // Right
        12, 13, 14,
        14, 15, 12,
        
        // Top
        16, 17, 18,
        18, 19, 16,
        
        // Bottom
        20, 21, 22,
        22, 23, 20
    ]
    
    init(shader: ShaderProgram) {
        super.init(name: "cube", shaderProgram: shader, vertices: vertexList, indices: indexList)
        self.loadTexture("dungeon_01.png")
    }
    
    /*override func updateWithDelta(_ dt: TimeInterval) {
        if self.rotating == true {
            //self.rotationY = self.rotationY + Float((Double.pi/8)*dt)
            //self.rotationX = self.rotationX + Float((Double.pi/8)*dt)
        }(
    }*/
    
    override func drawContent() {
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_INT), nil)
    }
    
}
