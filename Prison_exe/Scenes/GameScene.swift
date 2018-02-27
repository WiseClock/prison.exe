//
//  GameScene.swift
//
//  Created by Ryan Dieno on 2018-02-18.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

// scene that holds our main gameplay logic
class GameScene: Scene {
    var gameArea: CGSize
    let sceneOffset: Float
    
    var previousTouchLocation = CGPoint.zero
    
    var player: Player
    var platform: Cube
    
    init(shaderProgram: ShaderProgram) {
        
        // setup a virtual game size so we have a manageable work area
        self.gameArea = CGSize(width: 27, height: 48)
        
        // calculate scene offset to determine how far back we need to move the camera
        let x = self.gameArea.height / 2
        let y = tanf(GLKMathDegreesToRadians(85/2))
        self.sceneOffset = Float(x) / y

        // initialize player with properties
        
        let playerX = Float(self.gameArea.width / 2)
        let playerY = Float(self.gameArea.height * 0.2 + 3.75 + 1)
        let playerZ : Float = 2.0
        
        //let playerPosition = GLKVector3Make(Float(self.gameArea.width / 2), Float(self.gameArea.height * 0.2 + 3.75 + 1), 2.0)
        let playerPosition = GLKVector3Make(playerX, playerY, playerZ)
        
        self.player = Player(shader: shaderProgram, levelWidth: 20.0, initialPosition: playerPosition)
        self.player.position = playerPosition

        // initialize platform with properties
        self.platform = Cube(shader: shaderProgram)
        self.platform.scaleY = 200.0
        self.platform.scaleX = 20.0
        self.platform.rotationX = GLKMathDegreesToRadians(90)
        self.platform.position = GLKVector3Make(Float(self.gameArea.width / 2),
                                                Float(self.gameArea.height * 0.2), -75.0)
        
        super.init(name: "GameScene", shaderProgram: shaderProgram)
        
        // create the initial scene position so (x,y): (0, 0) is the center of the screen
        self.position = GLKVector3Make(Float(-self.gameArea.width / 2),
                                       Float(-self.gameArea.height / 2),
                                       -self.sceneOffset)
        
        // rotate camera view to angle down 15 degrees
        self.rotationX = GLKMathDegreesToRadians(15)
        
        // add objects as children of the scene
        self.children.append(self.player)
        self.children.append(self.platform)
        
    }
    
    override func updateWithDelta(_ dt: TimeInterval) {
        super.updateWithDelta(dt)
        
    }
    
    // convert a touch location to actual game space coordinates
    func touchLocationToGameArea(_ touchLocation: CGPoint) -> CGPoint {
        guard let manager = self.manager else { return .zero }
        let ratio = manager.glkView.frame.size.height / self.gameArea.height
        let x = touchLocation.x / ratio
        let y = (manager.glkView.frame.size.height - touchLocation.y) / ratio
        return CGPoint(x: x, y: y)
    }
    
    override func touchGestureSwipedLeft(_ sender: UISwipeGestureRecognizer) {
        player.move(direction: sender.direction)
    }
    
    override func touchGestureSwipedRight(_ sender: UISwipeGestureRecognizer) {
        player.move(direction: sender.direction)
    }
    
    override func touchGestureSwipedUp(_ sender: UISwipeGestureRecognizer) {
        player.move(direction: sender.direction)
    }
    
    override func touchGestureSwipedDown(_ sender: UISwipeGestureRecognizer) {
        player.move(direction: sender.direction)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
