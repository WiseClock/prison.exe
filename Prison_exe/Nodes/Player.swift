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
class Player : PhysicsNode {
    
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
    
    let normalYOffset: Float
    
    var totalTime: Double = 0
    var updates: Int = 0
    var crouchTimer: Double = 0
    var timeGap: Double = 0
    
    static let playerShader: ShaderProgram = ShaderProgram.init(vertexShader: "Obstacle.vsh", fragmentShader: "Player.fsh")
    static let modelRun: ObjModel = ObjModel.init(Bundle.main.path(forResource: "player1", ofType: "obj")!, shader: Player.playerShader, texture: "player_run")
    static let modelRun2: ObjModel = ObjModel.init(Bundle.main.path(forResource: "player2", ofType: "obj")!, shader: Player.playerShader, texture: "player_run2")
    static let modelJump: ObjModel = ObjModel.init(Bundle.main.path(forResource: "player3", ofType: "obj")!, shader: Player.playerShader, texture: "player_jump")
    static let modelCrouch: ObjModel = ObjModel.init(Bundle.main.path(forResource: "player4", ofType: "obj")!, shader: Player.playerShader, texture: "player_crouch")
    
    init(shader: ShaderProgram, levelWidth: Float, initialPosition: GLKVector3) {
        self.isMoving = false
        self.maxMoveLength = 0.0
        
        // set movement speed
        self.speed = 50.0
        
        // calculate distance between each lane
        self.laneDistance = levelWidth / 3.0
        
        // set inital lane
        self.currentLane = Lane.middle
        self.currentMoveDirection = UISwipeGestureRecognizerDirection.left
        
        self.initialPosition = initialPosition;
        normalYOffset = initialPosition.y
        
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
        
        //super.init(shader: shader)
        
        Player.playerShader.projectionMatrix = shader.projectionMatrix
        
        super.init(name: "player", shaderProgram: shader, vertices: vertexList, indices: indexList)
        self.loadTexture("dungeon_01.png")
        
        // set color and size of players bounding box
        self.matColor = GLKVector4Make(1, 1, 1, 1)
        self.scaleY = 7.5
        self.scaleX = 4.0
        self.scaleZ = 4.0
        
        // save the initial Y scale
        self.initalScaleY = self.scaleY
        
        // calculate how much to translate by so the player stays grounded when crouching
        self.crouchTranslateHeight = minCrouchFactor * self.scaleY
        
        // calculate the proper min crouch factor by multiplying with the scale
        self.minCrouchFactor *= self.scaleY
        
        if (Player.modelRun.physicsInfo.getTag() != kNoCollisionTag)
        {
            Player.modelRun.setupPhysicsInfo(tag: kNoCollisionTag)
        }
        Player.modelRun.rotationY = 135
        Player.modelRun.position = GLKVector3Make(0, -0.8, 0.3)
        Player.modelRun.scaleY = 0.8
        Player.modelRun.scaleX = 1.2
        Player.modelRun.parent = self
        
        if (Player.modelRun2.physicsInfo.getTag() != kNoCollisionTag)
        {
            Player.modelRun2.setupPhysicsInfo(tag: kNoCollisionTag)
        }
        Player.modelRun2.rotationY = 135
        Player.modelRun2.position = GLKVector3Make(0, -0.8, 0.3)
        Player.modelRun2.scaleY = 0.8
        Player.modelRun2.scaleX = 1.2
        Player.modelRun2.parent = self
        
        if (Player.modelJump.physicsInfo.getTag() != kNoCollisionTag)
        {
            Player.modelJump.setupPhysicsInfo(tag: kNoCollisionTag)
        }
        Player.modelJump.rotationY = 135
        Player.modelJump.position = GLKVector3Make(0, -1.3, 0.3)
        Player.modelJump.scaleY = 0.8
        Player.modelJump.scaleX = 1.2
        Player.modelJump.parent = self
        
        if (Player.modelCrouch.physicsInfo.getTag() != kNoCollisionTag)
        {
            Player.modelCrouch.setupPhysicsInfo(tag: kNoCollisionTag)
        }
        Player.modelCrouch.rotationY = 135
        Player.modelCrouch.position = GLKVector3Make(0, -0.3, 0.3)
        Player.modelCrouch.scaleY = 0.8
        Player.modelCrouch.scaleX = 1.2
        Player.modelCrouch.parent = self
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
        
        totalTime += dt
        
        glUseProgram(Player.playerShader.programHandle)
        glUniform1f(glGetUniformLocation(Player.playerShader.programHandle, "u_Time"), GLfloat(self.totalTime))
        
        if (isCrouching)
        {
            self.children.removeAll()
            self.children.append(Player.modelCrouch)
        }
        else if (isJumping)
        {
            self.children.removeAll()
            self.children.append(Player.modelJump)
        }
        else
        {
            timeGap += dt
            if (timeGap > 0.2)
            {
                updates += 1
                timeGap = 0
                
                if (updates % 2 == 0)
                {
                    self.children.removeAll()
                    self.children.append(Player.modelRun)
                }
                else
                {
                    self.children.removeAll()
                    self.children.append(Player.modelRun2)
                }
            }
        }
        
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
                    crouchTimer += dt
                    if(crouchTimer < 1) {
                        self.position.y = normalYOffset - 4
                    } else {
                        self.isCrouching = false;
                        crouchTimer = 0
                        self.position.y = normalYOffset
                    }
                    
                    //begin crouching
                    /*
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
                     */
                } else {
                    self.isMoving = false
                    self.position.y = normalYOffset
                    /*
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
                    */
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
