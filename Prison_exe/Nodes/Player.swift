//
//  Player.swift
//  Prison_exe
//
//  Created by Ryan Dieno on 2018-02-21.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit
import UIKit

// keeps track of the lane the player is in
enum Lane : GLuint {
    case left = 0
    case middle = 1
    case right = 2
}

// our human controllable player object
class Player : Cube {
    // is the player currently moving between lanes
    var isMoving : Bool
    
    // sets left and right lane distance from center
    var maxMoveLength: Float
    
    // how fast the player moves left and right
    var speed : Float
    
    // used to calculate absolute value of x distance between lanes
    var laneDistance : Float
    
    // keeps track of which lane the player is currently in
    var currentLane : Lane
    
    // which direction is the player currently moving in (up, down, left or right)
    var currentMoveDirection : UISwipeGestureRecognizerDirection
    
    // saves the initial player position in our scenes coordinate system
    var initialPosition: GLKVector3
    
    // is the player currently jumping
    var isJumping: Bool
    
    // how high does the character jump (relative)
    var jumpHeight: Float
    
    // keeps track of how long the player has been at its peack jump height
    var jumpHang: Float
    
    // max y position the character will reach when jumping (scene coordinates)
    var maxJumpHeight: Float
    
    // how long the player hang in the air when jumping
    var maxJumpHang: Float
    
    // is the player currently crouching
    var isCrouching: Bool
    
    // keeps track of the initial Y scale of the player
    var initalScaleY : Float
    
    // how much are we scaling down to when we crouch
    var minCrouchFactor: Float
    
    // how much the player is currently scaling
    var crouchFactor: Float
    
    // keeps track of how long the player is haning at min scale
    var crouchHang : Float
    
    // how long the player hangs at the min scale
    var maxCrouchHang : Float
    
    // how much is the player translating downwards when crouching (so the bottom of the object stays fixed to the level)
    var crouchTranslateHeight : Float
    
    // checks if the controls are swapped
    var isControlsSwapped : Bool
    
    init(shader: ShaderProgram, levelWidth: Float, initialPosition: GLKVector3) {
        self.isMoving = false
        self.maxMoveLength = 0.0
        
        // set movement speed
        self.speed = 50.0
        
        // calculate distance between each lane
        self.laneDistance = levelWidth / 4.0
        
        // set inital lane
        self.currentLane = Lane.middle
        self.currentMoveDirection = UISwipeGestureRecognizerDirection.left
        
        self.initialPosition = initialPosition;
        
        // initalize jumping variables
        self.isJumping = false
        self.jumpHeight = 10.0
        self.maxJumpHeight = initialPosition.y + self.jumpHeight
        self.jumpHang = 0.0
        self.maxJumpHang = 0.25
        
        // initalize crouching variables
        self.isCrouching = false
        self.initalScaleY = 0.0
        self.minCrouchFactor = 0.5
        self.crouchFactor = 0.0
        self.crouchHang = 0.0
        self.maxCrouchHang = 0.25
        self.crouchTranslateHeight = 0.0
        
        self.isControlsSwapped = false;
        
        super.init(shader: shader)
        
        // set color and size of players bounding box
        self.matColor = GLKVector4Make(1, 0, 1, 1)
        self.scaleY = 7.5
        self.scaleX = 4.0
        self.scaleZ = 4.0
        
        // save the initial Y scale
        self.initalScaleY = self.scaleY
        
        // calculate how much to translate by so the player stays grounded when crouching
        self.crouchTranslateHeight = minCrouchFactor * self.scaleY
        
        // calculate the proper min crouch factor by multiplying with the scale
        self.minCrouchFactor *= self.scaleY
    }
    
    // causes the player to begin moving
    func move(direction: UISwipeGestureRecognizerDirection) {
        if(!isMoving &&
            !(currentLane == Lane.left && direction == UISwipeGestureRecognizerDirection.left) &&
            !(currentLane == Lane.right && direction == UISwipeGestureRecognizerDirection.right))
        {
            switch(direction) {
            case UISwipeGestureRecognizerDirection.left:
                self.currentMoveDirection = UISwipeGestureRecognizerDirection.left
                // self.currentPositionX = self.position.x
                self.maxMoveLength = self.position.x - self.laneDistance
                
            case UISwipeGestureRecognizerDirection.right:
                currentMoveDirection = UISwipeGestureRecognizerDirection.right
                self.maxMoveLength = self.position.x + self.laneDistance
                
            case UISwipeGestureRecognizerDirection.up:
                currentMoveDirection = UISwipeGestureRecognizerDirection.up
                isJumping = true
                
            case UISwipeGestureRecognizerDirection.down:
                currentMoveDirection = UISwipeGestureRecognizerDirection.down
                self.isCrouching = true
                
            default:
                print("error: reached default case in player move function")
                
            }
            
            isMoving = true
        }
    }
    
    override func updateWithDelta(_ dt: TimeInterval) {
        super.updateWithDelta(dt)
        
        if(isMoving && !isControlsSwapped) {
            switch(currentMoveDirection) {
            case UISwipeGestureRecognizerDirection.left:
                // move from the middle lane to the left lane
                if(currentLane == Lane.middle) {
                    if(self.position.x != self.maxMoveLength) {
                        self.position.x -= self.speed * Float(dt)
                    } else {
                        self.currentLane = Lane.left
                        self.isMoving = false
                    }
                    
                    // if we go over, set the position
                    if(self.position.x < self.maxMoveLength) {
                        self.position.x = self.maxMoveLength
                    }
                    // move from the right lane to the middle lane
                } else if (currentLane == Lane.right) {
                    if(self.position.x != self.initialPosition.x) {
                        self.position.x -= self.speed * Float(dt)
                    } else {
                        self.currentLane = Lane.middle
                        self.isMoving = false
                    }
                    
                    // if we go over, set the position
                    if(self.position.x < self.initialPosition.x) {
                        self.position.x = self.initialPosition.x
                    }
                }
                else
                {
                    // swipe left at left lane
                    self.isMoving = false
                }
                
            case UISwipeGestureRecognizerDirection.right:
                // move from middle lane to the right lane
                if(currentLane == Lane.middle) {
                    if(self.position.x != self.maxMoveLength) {
                        self.position.x += self.speed * Float(dt)
                    } else {
                        self.currentLane = Lane.right
                        self.isMoving = false
                    }
                    
                    // if we go over, set the position
                    if(self.position.x > self.maxMoveLength) {
                        self.position.x = self.maxMoveLength
                    }
                    // move from left lane to the middle lane
                } else if (currentLane == Lane.left) {
                    if(self.position.x != self.initialPosition.x) {
                        self.position.x += self.speed * Float(dt)
                    } else {
                        self.currentLane = Lane.middle
                        self.isMoving = false
                    }
                    
                    // if we go over, set the position
                    if(self.position.x > self.initialPosition.x) {
                        self.position.x = self.initialPosition.x
                    }
                }
                else
                {
                    // swipe right when at right lane
                    self.isMoving = false
                }
                
            case UISwipeGestureRecognizerDirection.up:
                
                // TODO: change this to a parabola or sin function for smooth jumping
                // TODO: consider adding gravity for falling through gaps
                
                // begin jumping
                if(isJumping) {
                    if(self.position.y != self.maxJumpHeight) {
                        self.position.y += self.speed * Float(dt)
                    } else {
                        // once we reach our max height, begin to hang
                        self.jumpHang += Float(dt)
                        if(self.jumpHang >= self.maxJumpHang) {
                            self.jumpHang = 0.0
                            self.isJumping = false
                        }
                    }
                    
                    // if we go to high, set the positon
                    if(self.position.y > self.maxJumpHeight) {
                        self.position.y = self.maxJumpHeight
                    }
                } else {
                    // fall back down until player is grounded
                    if(self.position.y != self.initialPosition.y) {
                        self.position.y -= self.speed * Float(dt)
                    } else {
                        self.isMoving = false
                    }
                    
                    // if we pass the floor, set the positon
                    if(self.position.y < self.initialPosition.y) {
                        self.position.y = self.initialPosition.y
                    }
                }
                
            case UISwipeGestureRecognizerDirection.down:
                if(isCrouching) {
                    //begin crouching
                    if(self.scaleY != self.minCrouchFactor) {
                        self.scaleY -= self.speed * Float(dt)
                        self.position.y -= (self.speed * 0.5) * Float(dt)
                    } else {
                        // once we reach our min crouch factor, begin to hang
                        self.crouchHang += Float(dt);
                        if(self.crouchHang >= maxCrouchHang) {
                            self.crouchHang = 0.0
                            self.isCrouching = false;
                        }
                    }
                    
                    // if we scale too small, set the scale
                    if(self.scaleY < self.minCrouchFactor) {
                        self.scaleY = self.minCrouchFactor
                    }
                } else {
                    // scale back up to our inital scale
                    if(self.scaleY != self.initalScaleY) {
                        self.scaleY += self.speed * Float(dt)
                        self.position.y += (self.speed * 0.5) * Float(dt)
                    } else {
                        self.isMoving = false
                    }
                    
                    // if we scale to big, set the scale
                    if(self.scaleY > self.initalScaleY) {
                        self.scaleY = self.initalScaleY
                    }
                }
                
            default:
                print("error: reached default case in player update function")
            }
        }
    }
}

