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
    
    func swapControls(_ dt: TimeInterval) {
        super.updateWithDelta(dt);
        
        player.isControlsSwapped = true;
        
        if(player.isControlsSwapped && isTouched) {
            switch(player.currentMoveDirection) {
            case UISwipeGestureRecognizerDirection.right:
                // move from the middle lane to the left lane
                if(currentLane == Lane.middle) {
                    if(player.position.x != player.maxMoveLength) {
                        player.position.x -= player.speed * Float(dt)
                    } else {
                        player.currentLane = Lane.left
                        player.isMoving = false
                    }
                    
                    // if we go over, set the position
                    if(player.position.x < player.maxMoveLength) {
                        player.position.x = player.maxMoveLength
                    }
                    // move from the right lane to the middle lane
                } else if (currentLane == Lane.right) {
                    if(player.position.x != player.initialPosition.x) {
                        player.position.x -= player.speed * Float(dt)
                    } else {
                        player.currentLane = Lane.middle
                        player.isMoving = false
                    }
                    
                    // if we go over, set the position
                    if(player.position.x < player.initialPosition.x) {
                        player.position.x = player.initialPosition.x
                    }
                }
                
            case UISwipeGestureRecognizerDirection.left:
                // move from middle lane to the right lane
                if(currentLane == Lane.middle) {
                    if(player.position.x != player.maxMoveLength) {
                        player.position.x += player.speed * Float(dt)
                    } else {
                        player.currentLane = Lane.right
                        player.isMoving = false
                    }
                    
                    // if we go over, set the position
                    if(player.position.x > player.maxMoveLength) {
                        player.position.x = player.maxMoveLength
                    }
                    // move from left lane to the middle lane
                } else if (currentLane == Lane.left) {
                    if(player.position.x != player.initialPosition.x) {
                        player.position.x += player.speed * Float(dt)
                    } else {
                        player.currentLane = Lane.middle
                        player.isMoving = false
                    }
                    
                    // if we go over, set the position
                    if(player.position.x > player.initialPosition.x) {
                        player.position.x = player.initialPosition.x
                    }
                }
                
            case UISwipeGestureRecognizerDirection.down:
                
                // TODO: change this to a parabola or sin function for smooth jumping
                // TODO: consider adding gravity for falling through gaps
                
                // begin jumping
                if(player.isJumping) {
                    if(player.position.y != player.maxJumpHeight) {
                        player.position.y += player.speed * Float(dt)
                    } else {
                        // once we reach our max height, begin to hang
                        player.jumpHang += Float(dt)
                        if(player.jumpHang >= player.maxJumpHang) {
                            player.jumpHang = 0.0
                            player.isJumping = false
                        }
                    }
                    
                    // if we go to high, set the positon
                    if(player.position.y > player.maxJumpHeight) {
                        player.position.y = player.maxJumpHeight
                    }
                } else {
                    // fall back down until player is grounded
                    if(player.position.y != player.initialPosition.y) {
                        player.position.y -= player.speed * Float(dt)
                    } else {
                        player.isMoving = false
                    }
                    
                    // if we pass the floor, set the positon
                    if(player.position.y < player.initialPosition.y) {
                        player.position.y = player.initialPosition.y
                    }
                }
                
            case UISwipeGestureRecognizerDirection.up:
                if(player.isCrouching) {
                    //begin crouching
                    if(player.scaleY != player.minCrouchFactor) {
                        player.scaleY -= player.speed * Float(dt)
                        player.position.y -= (player.speed * 0.5) * Float(dt)
                    } else {
                        // once we reach our min crouch factor, begin to hang
                        player.crouchHang += Float(dt);
                        if(player.crouchHang >= player.maxCrouchHang) {
                            player.crouchHang = 0.0
                            player.isCrouching = false;
                        }
                    }
                    
                    // if we scale too small, set the scale
                    if(player.scaleY < player.minCrouchFactor) {
                        player.scaleY = player.minCrouchFactor
                    }
                } else {
                    // scale back up to our inital scale
                    if(player.scaleY != player.initalScaleY) {
                        player.scaleY += player.speed * Float(dt)
                        player.position.y += (player.speed * 0.5) * Float(dt)
                    } else {
                        player.isMoving = false
                    }
                    
                    // if we scale to big, set the scale
                    if(player.scaleY > player.initalScaleY) {
                        player.scaleY = player.initalScaleY
                    }
                }
                
            default:
                print("error: reached default case in player update function")
            }
        }
        
    }
    
    override func drawContent() {
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_INT), nil)
    }
    
}
