//
//  GameOverScene.swift
//
//  Created by Ryan Dieno on 2018-02-19.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

class GameOverScene: Scene {
    var contentView: GameOverView!
    
    init(shaderProgram: ShaderProgram, view: GLKView) {
        super.init(name: "GameOverScene", shaderProgram: shaderProgram)
        self.contentView = GameOverView.init(frame: view.frame)
        self.contentView.scene = self
        view.addSubview(self.contentView)
    }
    
    func playAgainButtonPressed() {
        self.contentView.removeFromSuperview()
        self.manager?.scene = GameScene.init(shaderProgram: (self.manager?.shaderProgram)!)
        self.manager?.playBtnNoise();
    }
    
    func highScoresButtonPressed() {
        self.contentView.removeFromSuperview()
        self.manager?.scene = HighScoresScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)
        self.manager?.playBtnNoise();
    }
    
    func mainMenuButtonPressed() {
        self.contentView.removeFromSuperview()
        self.manager?.scene = MainMenuScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)
        self.manager?.playBtnNoise();
    }
}
