//
//  HelpScene.swift
//  Prison_exe
//
//  Created by Matt G on 2018-02-27.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit
class HelpScene: Scene {
    var contentView: HelpView!
    
    init(shaderProgram: ShaderProgram, view: GLKView) {
        super.init(name: "HelpScene", shaderProgram: shaderProgram)
        self.contentView = HelpView.init(frame: view.frame)
        self.contentView.scene = self
        view.addSubview(self.contentView)
    }
    
    func howToPlayButtonPressed() {
        self.contentView.removeFromSuperview()

        self.manager?.scene = ReadmeScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)

        self.manager?.playBtnNoise();
    }
    
    func storylineButtonPressed() {
        self.contentView.removeFromSuperview()

        self.manager?.scene = StoryScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)

        self.manager?.playBtnNoise();
    }
    
    func creditsButtonPressed() {
        self.contentView.removeFromSuperview()
        
        self.manager?.scene = CreditsScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)
        self.manager?.playBtnNoise()
    }
    
    func backButtonPressed() {
        self.contentView.removeFromSuperview()
        self.manager?.scene = MainMenuScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)

        self.manager?.playBtnNoise();
    }
    
    
}
