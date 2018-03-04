//
//  GameOverScene.swift
//
//  Created by Ryan Dieno on 2018-02-19.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

class HighScoresScene: Scene {
    var contentView: HighScoresView!
    
    init(shaderProgram: ShaderProgram, view: GLKView) {
        super.init(name: "HighScoresScene", shaderProgram: shaderProgram)
        self.contentView = HighScoresView.init(frame: view.frame)
        self.contentView.scene = self
        view.addSubview(self.contentView)
    }
    
    func playGameButtonPressed() {
        self.contentView.removeFromSuperview()
        self.manager?.scene = GameScene.init(shaderProgram: (self.manager?.shaderProgram)!)
    }
    
    func mainMenuButtonPressed() {
        self.contentView.removeFromSuperview()
        self.manager?.scene = MainMenuScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)
    }
    
    
}
