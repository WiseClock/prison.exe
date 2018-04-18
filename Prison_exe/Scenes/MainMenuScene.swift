//
//  MainMenuScene.swift
//  Prison_exe
//
//  Created by Matt G on 2018-02-27.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit
class MainMenuScene: Scene {
    var contentView: MainMenuView!
    
    init(shaderProgram: ShaderProgram, view: GLKView) {
        super.init(name: "MainMenuScene", shaderProgram: shaderProgram)
        self.contentView = MainMenuView.init(frame: view.frame)
        self.contentView.scene = self
        view.addSubview(self.contentView)
    }
    
    func playButtonPressed() {
        self.contentView.removeFromSuperview()

        //self.manager?.scene = GameScene.init(shaderProgram: (self.manager?.shaderProgram)!)
        self.manager?.playBtnNoise();
        self.manager?.stopBackgroundMusic()

        let ps : PrologueScene = PrologueScene.init(shaderProgram: (self.manager?.shaderProgram)!)
        // gs.lineShaderProgram = self.manager?.lineShaderProgram
        
        // resets score if a previously game had been played
        self.manager?.updateScore(score: 0)
        self.manager?.scorelabel?.isHidden = true
        
        self.manager?.scene = ps;
        self.manager?.playBtnNoise();
        self.manager?.stopBackgroundMusic()

    }
    
    func highScoresButtonPressed() {
        self.contentView.removeFromSuperview()
        //self.manager?.scene = HighScoresScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)

        let hss = HighScoresScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)
        self.manager?.scene = hss
        hss.loadHighScores()
        
        self.manager?.playBtnNoise();

        
    }
    
    func helpButtonPressed() {
        self.contentView.removeFromSuperview()
        self.manager?.scene = HelpScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)
        self.manager?.playBtnNoise();
    }
}
