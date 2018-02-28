//
//  GameScene.swift
//
//  Created by Ryan Dieno on 2018-02-18.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

// scene that holds our main gameplay logic
class GameScene: Scene {
    let maxPlatformSize: Int = 10;
    let obstacleScale: Float = 7.0 // one meter
    
    var gameArea: CGSize
    let sceneOffset: Float
    
    var previousTouchLocation = CGPoint.zero
    
    var player: Player
    var platforms: Cube
    
    let obstacleNames = ["bcit"]
    var obstacles = [MDLAsset]()
    
    // per second
    let velocity: Double = 1
    
    //var powerdown: PowerDown
    
    init(shaderProgram: ShaderProgram) {
        
        // import obstacles
        for name in obstacleNames
        {
            guard let url = Bundle.main.url(forResource: name, withExtension: "obj")
                else
                {
                    fatalError("Failed to find model file.")
                }
            let asset = MDLAsset(url: url)
            obstacles.append(asset)
        }
        
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
        
        platforms = Cube(shader: shaderProgram)
        platforms.scaleY = 1
        platforms.scaleX = 1
        platforms.position = GLKVector3Make(Float(self.gameArea.width / 2), Float(self.gameArea.height * 0.2), 0)
        
        
        
        super.init(name: "GameScene", shaderProgram: shaderProgram)
        
        // initialize platform with properties
        for index in 1 ... maxPlatformSize
        {
            let platform = buildPlatform(atZ: -1 * obstacleScale * Float(index - 1))
            self.platforms.children.append(platform)
        }
        
        // create the initial scene position so (x,y): (0, 0) is the center of the screen
        self.position = GLKVector3Make(Float(-self.gameArea.width / 2),
                                       Float(-self.gameArea.height / 2),
                                       -self.sceneOffset)
        
        // rotate camera view to angle down 15 degrees
        self.rotationX = GLKMathDegreesToRadians(15)
        
        // add objects as children of the scene
        self.children.append(self.player)
        self.children.append(self.platforms)
        //self.children.append(self.powerdown)
        
    }
    
    override func updateWithDelta(_ dt: TimeInterval) {
        super.updateWithDelta(dt)
        
        // in frame velocity
        let v = velocity * dt
        movePlatforms(velocity: v)
    }
    
    func buildPlatform(atZ: Float) -> Cube
    {
        let platform: Cube = Cube(shader: shaderProgram)
        platform.scaleY = 1 * obstacleScale
        platform.scaleX = 3 * obstacleScale
        platform.rotationX = GLKMathDegreesToRadians(90)
        platform.position = GLKVector3Make(0, 0, atZ)
        
        
        
        if (atZ < Float(maxPlatformSize) / 2 * -obstacleScale)
        {
            let obstable: Cube = Cube(shader: shaderProgram)
            obstable.scaleY = 1 * 0.7
            obstable.scaleX = 1 / 3 * 0.7
            obstable.scaleZ = 1 * obstacleScale * 0.7
            obstable.position = GLKVector3Make(0, 0.5, -1/2 * obstacleScale) // x,z,y
            
            // power down
            let powerX = Float(self.gameArea.width / 2)
            let powerY = Float(self.gameArea.height * 0.2 + 3.75 + 1)
            let powerZ : Float = -30.0
            let powerPosition = GLKVector3Make(powerX, powerY, powerZ)
            let powerdown = PowerDown(shader: shaderProgram, levelWidth: 20.0, initialPosition: powerPosition, player: player)
            //powerdown.position = GLKVector3Make(0.25, 0.25, -2)
            
            powerdown.scaleY = 1 * 0.7 * 0.5
            powerdown.scaleX = 1 / 3 * 0.7 * 0.5
            powerdown.scaleZ = 1 * obstacleScale * 0.7 * 0.5
            powerdown.position = GLKVector3Make(0, 0.5, -1/2 * obstacleScale) // x,z,y
            
            // power up
            let powerup = PowerUp(shader: shaderProgram, levelWidth: 20.0, initialPosition: powerPosition)
            //powerdown.position = GLKVector3Make(0.25, 0.25, -2)
            
            powerup.scaleY = 1 * 0.7 * 0.5
            powerup.scaleX = 1 / 3 * 0.7 * 0.5
            powerup.scaleZ = 1 * obstacleScale * 0.7 * 0.5
            powerup.position = GLKVector3Make(0, 0.5, -1/2 * obstacleScale) // x,z,y
            
            let positionHorizontal: Int = Int(arc4random_uniform(UInt32(3)))
            switch (positionHorizontal)
            {
            case 0:
                // left
                obstable.position.x -= 1/3
                break;
            case 1:
                // middle
                // powerdown right
                powerdown.position.x += 1/3
                powerup.position.x += 1/3
                break;
            case 2:
                // right
                obstable.position.x += 1/3
                // powerdown left
                powerdown.position.x -= 1/3
                powerup.position.x -= 1/3
                break;
            default:
                break;
            }
            
            let positionVertical: Int = Int(arc4random_uniform(UInt32(3)))
            switch (positionVertical)
            {
            case 0:
                // top
                obstable.position.z -= obstacleScale
                break;
            case 1:
                // center
                break;
            case 2:
                // bottom
                obstable.position.z += 1/2 * obstacleScale
                break;
            default:
                break;
            }
            
            let appendExtras: Int = Int(arc4random_uniform(UInt32(6)))
            switch (appendExtras)
            {
            case 0:
                platform.children.append(obstable)
                break;
            case 1:
                platform.children.append(obstable)
                break;
            case 2:
                platform.children.append(powerdown)
                break;
            case 3:
                break;
            case 4:
                break;
            case 5:
                platform.children.append(powerup)
                break;
            default:
                break;
            }

        }
        
        return platform
    }
    
    func movePlatforms(velocity: Double)
    {
        for platform in self.platforms.children
        {
            platform.position.z += Float(velocity) * obstacleScale
        }
        
        // delete platfroms cant be seen
        var index = self.platforms.children.index(where: { (item) -> Bool in
            item.position.z >= obstacleScale * 1.5
        })
        while (index != nil)
        {
            self.platforms.children.remove(at: index!)
            
            // add new
            let lastZPos = self.platforms.children.last?.position.z
            let newCube: Cube = buildPlatform(atZ: lastZPos! - 1 * obstacleScale)
            self.platforms.children.append(newCube)
            
            index = self.platforms.children.index(where: { (item) -> Bool in
                item.position.z >= obstacleScale * 1.5
            })
        }
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
