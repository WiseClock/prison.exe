//
//  PowerDown.swift
//  Prison_exe
//
//  Created by Robert Broyles on 2018-02-27.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit
import UIKit

// a single power-down: swap controls
class PowerDown : PhysicsNode {
    
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
    
    
    // the player
    var player : Player
    
    // keeps track of which lane the power-up is currently in
    var currentLane : Lane
    
    // saves the initial position in our scenes coordinate system
    var initialPosition: GLKVector3
    
    // check if touched
    var isTouched : Bool
    
    init(shader: ShaderProgram, levelWidth: Float, initialPosition: GLKVector3, player: Player) {
        isTouched = false;
        
        // set lane
        self.currentLane = Lane.middle;
        self.initialPosition = initialPosition;
        self.player = player;
        
        super.init(name: "powerdown", shaderProgram: shader, vertices: vertexList, indices: indexList)
        self.loadTexture("dungeon_01.png")
        
        // set color and size of power-up
        self.matColor = GLKVector4Make(1, 0, 0, 1)
        //self.scaleY = 2.0
        //self.scaleX = 2.0
        //self.scaleZ = 2.0
    }
    
    override func drawContent() {
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_INT), nil)
    }
    
}
