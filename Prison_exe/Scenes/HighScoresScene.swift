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
        self.manager?.playBtnNoise();
        self.manager?.stopBackgroundMusic()
        self.manager?.playBackgroundMusic(file: "game.mp3")
    }
    
    func mainMenuButtonPressed() {
        self.contentView.removeFromSuperview()
        self.manager?.scene = MainMenuScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)
        self.manager?.playBtnNoise();
    }
    
    
}
