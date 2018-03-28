//
//  GameScene.swift
//
//  Created by Ryan Dieno on 2018-02-18.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

// scene that holds our main gameplay logic
class GameScene: Scene {
    let maxPlatformSize: Int = 20;
    let obstacleScale: Float = 7.0 // one meter
    
    var gameArea: CGSize
    let sceneOffset: Float
    
    var previousTouchLocation = CGPoint.zero
    
    var player: Player
    var platforms: Node
    
    // shaders
    static var shaders = [
        ShaderProgram.init(vertexShader: "Platform.vsh", fragmentShader: "Platform.fsh")
    ]
    
    var obstacleAssets = [
        [
            "FireHydrant",
            [EObstaclePosition.Left, EObstaclePosition.Middle, EObstaclePosition.Right],
            [EObstaclePosition.Center],
            shaders[0]
        ]
    ]
    var obstacles = [ObstacleBaby]()
    
    // per second
    let velocity: Double = 1
    
    init(shaderProgram: ShaderProgram) {
        
        // init shaders
        for shader in GameScene.shaders
        {
            shader.projectionMatrix = shaderProgram.projectionMatrix
        }
        
        // import obstacles
        for asset in obstacleAssets
        {
            let name: String = asset[0] as! String
            obstacles.append(ObstacleBaby.init(name, shader: shaderProgram, horizontalPos: asset[1] as! [EObstaclePosition], verticlePos: asset[2] as! [EObstaclePosition]))
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
        
        platforms = Node(name: "empty", shaderProgram: shaderProgram)
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
    
    func buildPlatform(atZ: Float) -> Node
    {
        // let platform: Cube = Cube(shader: GameScene.shaders[0])
        let platform: ObjModel = ObjModel.init(Bundle.main.path(forResource: "platform", ofType: "obj")!, shader: GameScene.shaders[0], texture: "dungeon_01.png")
        platform.scaleX = 1 * obstacleScale
        platform.scaleY = 1 * obstacleScale
        platform.scaleZ = 1 * obstacleScale
        platform.position = GLKVector3Make(0, 0, atZ)
        
        if (atZ < Float(maxPlatformSize) / 2 * -obstacleScale)
        {
            let rand: Int = Int(arc4random_uniform(100))
            
            if (rand <= 20) // powerup
            {
                // power up
                let powerPosition = GLKVector3Make(0, 0, 0)
                let powerup = PowerUp(shader: shaderProgram, levelWidth: 20.0, initialPosition: powerPosition)
                
                powerup.scaleZ = 1 * 0.5
                powerup.scaleX = 1 * 0.5
                powerup.scaleY = 1 * 0.5
                
                let randPos: Int = Int(arc4random_uniform(3))
                switch (randPos)
                {
                case 0:
                    powerup.position.x -= 1
                    break;
                case 1:
                    break;
                case 2:
                    powerup.position.x += 1
                    break;
                default:
                    break;
                }
                
                platform.children.append(powerup)
                return platform
            }
            else if (rand <= 40) // powerdown
            {
                // power down
                let powerPosition = GLKVector3Make(0, 0, 0)
                let powerdown = PowerDown(shader: shaderProgram, levelWidth: 20.0, initialPosition: powerPosition, player: player)
                
                powerdown.scaleZ = 1 * 0.7 * 0.5
                powerdown.scaleX = 1 * 0.7 * 0.5
                powerdown.scaleY = 1 * 0.7 * 0.5
                
                let randPos: Int = Int(arc4random_uniform(3))
                switch (randPos)
                {
                case 0:
                    powerdown.position.x -= 1
                    break;
                case 1:
                    break;
                case 2:
                    powerdown.position.x += 1
                    break;
                default:
                    break;
                }
                
                platform.children.append(powerdown)
                return platform
            }
            else if (rand > 80)
            {
                return platform;
            }
            
            // obstacle
            
            let randomObstacleIndex: Int = Int(arc4random_uniform(UInt32(obstacles.count)))
            let obstacleBaby: ObstacleBaby = obstacles[randomObstacleIndex]
            let obstacle: ObjModel = obstacleBaby.instantiate()
            obstacle.scaleZ = 1 * 0.7
            obstacle.scaleX = 1 * 0.7
            obstacle.scaleY = 1 * 0.7
            obstacle.position = GLKVector3Make(0, 0, 0) // x,y,z
            
            let obstacleHorizontal: EObstaclePosition = obstacleBaby.getRandomHorizontal()
            let obstacleVerticle: EObstaclePosition = obstacleBaby.getRandomVerticle()

            switch (obstacleHorizontal)
            {
            case EObstaclePosition.Left:
                obstacle.position.x -= 1
                break;
            case EObstaclePosition.Middle:
                break;
            case EObstaclePosition.Right:
                obstacle.position.x += 1
                break;
            default:
                break;
            }
            
            switch (obstacleVerticle)
            {
            case EObstaclePosition.Top:
                obstacle.position.y += 8 // somewhat floating height
                break;
            case EObstaclePosition.Center:
                break;
            case EObstaclePosition.Bottom:
                break;
            default:
                break;
            }
            
            platform.children.append(obstacle)
            return platform
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
            let newCube: Node = buildPlatform(atZ: lastZPos! - 1 * obstacleScale)
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
