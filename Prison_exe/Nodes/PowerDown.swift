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
class PowerDown : Cube {
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
        
        super.init(shader: shader)
        
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
    
}
