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
    
    var totalTime: Double
    var graceTime: Double = 2
    
	// PowerUp and PowerDown
    var powerTimer: Double
    var powersOnScreen: Bool
	var powerChoice: Int
	var isScoreDoubled: Bool
	var isShielded: Bool
	var isSlowDown: Bool
	var isSpeedUp: Bool
	var isSwapControls: Bool
	var isFog: Bool
    
	var powerUps   = ["Double Scoring", "Shield", "Slow Down"]
	var powerDowns = ["Speed Up", "Swap Controls", "Fog"]
	
    // shaders
    static var shaders = [
        ShaderProgram.init(vertexShader: "Platform.vsh", fragmentShader: "Platform.fsh"),
        ShaderProgram.init(vertexShader: "Obstacle.vsh", fragmentShader: "Obstacle.fsh"),
        ShaderProgram.init(vertexShader: "Background.vsh", fragmentShader: "Background.fsh"),
        ShaderProgram.init(vertexShader: "Power.vsh", fragmentShader: "Power.fsh"),
        ShaderProgram.init(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "PowerObj.fsh"),
    ]
    
    var obstacleAssets = [
        [
            "FireHydrant",
            [EObstaclePosition.Left, EObstaclePosition.Middle, EObstaclePosition.Right],
            [EObstaclePosition.Bottom],
            shaders[1]
        ],
        [
            "airplane",
            [EObstaclePosition.Left, EObstaclePosition.Middle, EObstaclePosition.Right],
            [EObstaclePosition.Top],
            shaders[1]
        ],
        [
            "airplane2",
            [EObstaclePosition.Left, EObstaclePosition.Middle, EObstaclePosition.Right],
            [EObstaclePosition.Top],
            shaders[1]
        ],
        [
            "star",
            [EObstaclePosition.Left, EObstaclePosition.Middle, EObstaclePosition.Right],
            [EObstaclePosition.Center, EObstaclePosition.Bottom, EObstaclePosition.Top],
            shaders[1]
        ],
    ]
    var obstacles = [ObstacleBaby]()
    var powerQuad1: QuadPowers
    
    // per second
    var velocity: Double = 2
    
    var physicsWorld : PhysicsWorldWrapper = PhysicsWorldWrapper()
    
    var lineShaderProgram : LineShaderProgram?
    
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
            obstacles.append(ObstacleBaby.init(name, shader: asset[3] as! ShaderProgram, horizontalPos: asset[1] as! [EObstaclePosition], verticlePos: asset[2] as! [EObstaclePosition]))
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
    
        let playerPosition = GLKVector3Make(playerX, playerY, playerZ)
        
        self.totalTime = 0
        self.powersOnScreen = false
        self.powerTimer = 0
		self.powerChoice = 0
		self.isScoreDoubled = false
		self.isShielded = false
		self.isSlowDown = false
		self.isSpeedUp = false
		self.isSwapControls = false
		self.isFog = false
        
        self.player = Player(shader: shaderProgram, levelWidth: 20.0, initialPosition: playerPosition)
        self.player.position = playerPosition
        
        // sets up a bounding box and id tag for collisions
        self.player.setupPhysicsInfo(tag: kPlayerTag)

        // add players bounding box to the world
        self.physicsWorld.addCollisionObject(self.player.physicsInfo)
        
        platforms = Node(name: "empty", shaderProgram: shaderProgram)
        platforms.scaleY = 1
        platforms.scaleX = 1
        platforms.position = GLKVector3Make(Float(self.gameArea.width / 2), Float(self.gameArea.height * 0.2), 0)
        
        powerQuad1 = QuadPowers.init(shader: GameScene.shaders[3])
        
        super.init(name: "GameScene", shaderProgram: shaderProgram)
        
        // initialize platform with properties
        for index in 1 ... maxPlatformSize
        {
            let platform = buildPlatform(atZ: -1 * obstacleScale * Float(index - 1), false)
            platform.parent = self.platforms
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
        
        // background
        let bgDistance = Float(maxPlatformSize - 2) * obstacleScale
        let bg: Quad = Quad(shader: GameScene.shaders[2])
        bg.scaleY = 200
        bg.scaleX = 200
        bg.position = GLKVector3Make(Float(self.gameArea.width / 2), Float(self.gameArea.height * 0.2), -bgDistance)
        self.children.append(bg)
        
        // power icons
        powerQuad1.position = GLKVector3Make(2, Float(self.gameArea.height - 2), -20)
        powerQuad1.scaleX = 5
        powerQuad1.scaleY = 5
        powerQuad1.rotationX = GLKMathDegreesToRadians(-15)
        self.children.append(powerQuad1)
    }
    
    override func updateWithDelta(_ dt: TimeInterval) {
        super.updateWithDelta(dt)
        if (graceTime >= 0)
        {
            graceTime -= dt
        }
        
        physicsWorld.update(Float(dt));
		
		if(powerTimer <= 0) {
			powerTimer = 0
			powersOnScreen = false
			isScoreDoubled = false
			isShielded = false
			isSlowDown = false
			isSpeedUp = false
			isSwapControls = false
			isFog = false
		}
        
		// in frame velocity
		// check for slow down/speed up
		if (isSlowDown)
        {
			velocity = 1.5
		} else if(isSpeedUp) {
			velocity = 5
		} else {
			velocity = 3
		}
		
        let v = velocity * dt
        movePlatforms(velocity: v)
        
        // check current collisions
        let pn : PhysicsNode? = self.physicsWorld.checkCollisionAndReturnNode()
        collisionCheck: if(graceTime <= 0 && pn != nil) {
            // check what the player is colliding with
            let tag = pn!.physicsInfo.getTag()
            if (tag == kNoCollisionTag)
            {
                break collisionCheck
            }
            
            switch tag {
            case kObstacleTag:
                print("Collision detected: obstacle")
                // collision with obstacle detected, change scene to gameover scene
				if(!isShielded) {
					self.manager?.scene = GameOverScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)
				}
                break
            case kPowerupTag:
                print("Collision detected: power up \(powerUps[powerChoice])")
                powerTimer = 5				
				switch powerChoice
                {
                case 0:
                    isScoreDoubled = true
                    powerQuad1.setTexture("pu_score.png")
                    break
                case 1:
                    isShielded = true
                    powerQuad1.setTexture("pu_shield.png")
                    break
                case 2:
                    isSlowDown = true
                    powerQuad1.setTexture("pu_slow.png")
                    break
                default:
                    break
				}
                break
            case kPowerdownTag:
                print("Collision detected: power down \(powerDowns[powerChoice])")
                powerTimer = 5				
				switch powerChoice
                {
                case 0:
                    isSpeedUp = true
                    powerQuad1.setTexture("pd_fast.png")
                    break
                case 1:
                    isSwapControls = true
                    powerQuad1.setTexture("pd_swap.png")
                    break
                case 2:
                    // isFog = true
                    powerQuad1.setTexture("pd_fog.png")
                    break
                default:
                    break
				}
                break
            default:
                print("Collision Error: tag: " + String(tag))
                break
            }
            // remove the physics bounding box
            self.physicsWorld.removeCollisionObject(pn?.physicsInfo)
            
            // remove node from scene graph
            let myNode = pn as! Node
            for platform in self.platforms.children {
                let indexOfNode = platform.children.index(where: {$0.id == myNode.id})
                if(indexOfNode != nil) {
                    platform.children.remove(at: indexOfNode!)
                }
            }
        }
        
        // update platform shader time
        
        self.totalTime += dt
        self.powerTimer -= dt
        
        glUseProgram(GameScene.shaders[3].programHandle)
        glUniform1f(glGetUniformLocation(GameScene.shaders[3].programHandle, "u_PowerTime"), GLfloat(self.powerTimer / 5.0))
        
        glUseProgram(GameScene.shaders[0].programHandle)
        glUniform1f(glGetUniformLocation(GameScene.shaders[0].programHandle, "u_Time"), GLfloat(self.totalTime))
        
        glUseProgram(GameScene.shaders[1].programHandle)
        glUniform1f(glGetUniformLocation(GameScene.shaders[1].programHandle, "u_Time"), GLfloat(self.totalTime))
        
        glUseProgram(GameScene.shaders[2].programHandle)
        glUniform1f(glGetUniformLocation(GameScene.shaders[2].programHandle, "u_Time"), GLfloat(self.totalTime))
    }
    
    // renders object and all children with the loaded shader program
    override func render(with parentModelViewMatrix: GLKMatrix4) {
        let modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, self.modelMatrix)
        
        super.render(with: parentModelViewMatrix)
        
        // loads a new shader program and draws physics debug info (WARNING: FOR TESTING PURPOSES ONLY)
        // self.lineShaderProgram?.modelViewMatrix = modelViewMatrix
        // self.lineShaderProgram?.prepareToDraw()
        // self.physicsWorld.debugDraw()
    }
    
    func buildPlatform(atZ: Float, _ genObstacle: Bool = true) -> Node
    {
        // let platform: Cube = Cube(shader: GameScene.shaders[0])
        let platform: ObjModel = ObjModel.init(Bundle.main.path(forResource: "platform", ofType: "obj")!, shader: GameScene.shaders[0], texture: "platform.png")
        platform.setupPhysicsInfo(tag: kNoCollisionTag)
        //self.physicsWorld.addCollisionObject(platform.physicsInfo)
        
        platform.scaleX = 1 * obstacleScale
        platform.scaleY = 1 * obstacleScale
        platform.scaleZ = 1 * obstacleScale
        platform.position = GLKVector3Make(0, 0, atZ)
        
        if (genObstacle)
        {
            let rand: Int = Int(arc4random_uniform(100))
            powerChoice = Int(arc4random_uniform(3))
            
            // print("powerTimer = " + String(powerTimer))
            if(powerTimer <= 0) {
                if (rand <= 10 && powersOnScreen == false) // powerup
                {
                    // power up
                    let powerPosition = GLKVector3Make(0, 0, 0)
                    let powerup = PowerUp(shader: GameScene.shaders[4], levelWidth: 20.0, initialPosition: powerPosition)
                    
                    // set the node's parent so we can properly calculate position and scale
                    powerup.parent = platform
                    
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
                    
                    // sets up a bounding box and id tag for collisions
                    powerup.setupPhysicsInfo(tag: kPowerupTag)
                    // add bounding box to the world
                    self.physicsWorld.addCollisionObject(powerup.physicsInfo)
                    
                    platform.children.append(powerup)
					self.powersOnScreen = true
                    return platform
                }
                else if (rand <= 20 && powersOnScreen == false) // powerdown
                {
                    // power down
                    let powerPosition = GLKVector3Make(0, 0, 0)
                    let powerdown = PowerDown(shader: GameScene.shaders[4], levelWidth: 20.0, initialPosition: powerPosition, player: player)
                    
                    // set the node's parent so we can properly calculate position and scale
                    powerdown.parent = platform
                    
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
                    
                    // sets up a bounding box and id tag for collisions
                    powerdown.setupPhysicsInfo(tag: kPowerdownTag)
                    // add bounding box to the world
                    self.physicsWorld.addCollisionObject(powerdown.physicsInfo)
                    
                    platform.children.append(powerdown)
                    self.powersOnScreen = true
                    return platform
                }
                else if (rand > 80)
                {
                    return platform;
                }
            }
            
            // obstacle
            
            let randomObstacleIndex: Int = Int(arc4random_uniform(UInt32(obstacles.count)))
            let obstacleBaby: ObstacleBaby = obstacles[randomObstacleIndex]
            let obstacle: ObjModel = obstacleBaby.instantiate()
            obstacle.scaleZ = 1 * 0.7
            obstacle.scaleX = 1 * 0.7
            obstacle.scaleY = 1 * 0.7
            obstacle.position = GLKVector3Make(0, (obstacle.height * (obstacle.scaleY * obstacle.scale)) / 2.0, 0) // x,y,z
            
            // set the node's parent so we can properly calculate position and scale
            obstacle.parent = platform
            
            // sets up a bounding box and id tag for collisions
            obstacle.setupPhysicsInfo(tag: kObstacleTag)
            
            // add obstacle's bounding box to the world
            self.physicsWorld.addCollisionObject(obstacle.physicsInfo)
            
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
                obstacle.position.y += 1 // somewhat floating height
                break;
            case EObstaclePosition.Center:
                obstacle.position.y += 0.5
                break;
            case EObstaclePosition.Bottom:
                break;
            default:
                break;
            }
            
            platform.children.append(obstacle)
        }
        return platform
    }
    
    func movePlatforms(velocity: Double)
    {
        for platform in self.platforms.children
        {
            platform.position.z += Float(velocity) * obstacleScale
            if (powerTimer > 0.1)
            {
                var index = platform.children.index(where: { (item) -> Bool in
                    item.name == "powerup" || item.name == "powerdown"
                })
                while (index != nil)
                {
                    let power = platform.children.remove(at: index!)
                    if let ppn = power as? PhysicsNode
                    {
                        self.physicsWorld.removeCollisionObject(ppn.physicsInfo)
                    }
                    index = platform.children.index(where: { (item) -> Bool in
                        item.name == "powerup" || item.name == "powerdown"
                    })
                }
            }
        }
        
        // delete platfroms cant be seen
        var index = self.platforms.children.index(where: { (item) -> Bool in
            item.position.z >= obstacleScale * 1.5
        })
        while (index != nil)
        {
            let platform = self.platforms.children.remove(at: index!)
            if let ppn = platform as? PhysicsNode
            {
                self.physicsWorld.removeCollisionObject(ppn.physicsInfo)
            }
            
            // remove node from physics world
            for child in platform.children {
                if let pn = child as? PhysicsNode {
                    self.physicsWorld.removeCollisionObject(pn.physicsInfo)
                }
            }
            
            // add new
            let lastZPos = self.platforms.children.last?.position.z
            let newCube: Node = buildPlatform(atZ: lastZPos! - 1 * obstacleScale)
            
            // set the node's parent so we can properly calculate position and scale
            newCube.parent = self.platforms
            
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
        if (isSwapControls)
        {
            player.move(direction: UISwipeGestureRecognizerDirection.right)
        }
        else
        {
            player.move(direction: sender.direction)
        }
    }
    
    override func touchGestureSwipedRight(_ sender: UISwipeGestureRecognizer) {
        if (isSwapControls)
        {
            player.move(direction: UISwipeGestureRecognizerDirection.left)
        }
        else
        {
            player.move(direction: sender.direction)
        }
    }
    
    override func touchGestureSwipedUp(_ sender: UISwipeGestureRecognizer) {
        if (isSwapControls)
        {
            player.move(direction: UISwipeGestureRecognizerDirection.down)
        }
        else
        {
            player.move(direction: sender.direction)
        }
    }
    
    override func touchGestureSwipedDown(_ sender: UISwipeGestureRecognizer) {
        if (isSwapControls)
        {
            player.move(direction: UISwipeGestureRecognizerDirection.up)
        }
        else
        {
            player.move(direction: sender.direction)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
