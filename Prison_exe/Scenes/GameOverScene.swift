//
//  GameOverScene.swift
//
//  Created by Ryan Dieno on 2018-02-19.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

class GameOverScene: Scene {
    
    let gameArea: CGSize
    let sceneOffset: Float
    var timeSinceStart: TimeInterval = 0
    
    init(shaderProgram: ShaderProgram, win: Bool) {
        self.gameArea = CGSize(width: 27, height: 48)
        let x = self.gameArea.height / 2
        let y = tanf(GLKMathDegreesToRadians(90/2))
        self.sceneOffset = Float(x) / y
        
        super.init(name: "GameOverScene", shaderProgram: shaderProgram, vertices: [], indices: [])
        
        // create the initial scene position (i.e. camera)
        self.position = GLKVector3Make(Float(-self.gameArea.width / 2),
                                       Float(-self.gameArea.height / 2 + 10),
                                       -self.sceneOffset)
        
    }
    
    override func updateWithDelta(_ dt: TimeInterval) {
        super.updateWithDelta(dt)
        
        self.timeSinceStart += dt
        if timeSinceStart > 5 {
            guard let director = self.manager else { return }
            director.scene = GameScene(shaderProgram: self.shaderProgram)
            director.backgroundMusicPlayer?.play()
        }
    }
}
