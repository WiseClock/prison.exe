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
        self.manager?.scene = GameScene.init(shaderProgram: (self.manager?.shaderProgram)!)
    }
    
    func highScoresButtonPressed() {
        self.contentView.removeFromSuperview()
         self.manager?.scene = HighScoresScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)
        
    }
    
    func helpButtonPressed() {
        self.contentView.removeFromSuperview()
        self.manager?.scene = HelpScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)
    }
}