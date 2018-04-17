//
//  StoryScene.swift
//  Prison_exe
//
//  Created by Matt G on 2018-03-24.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

class StoryScene: Scene {
    var contentView: StoryView!
    
    init(shaderProgram: ShaderProgram, view: GLKView) {
        super.init(name: "StoryScene", shaderProgram: shaderProgram)
        self.contentView = StoryView.init(frame: view.frame)
        self.contentView.scene = self
        view.addSubview(self.contentView)
    }
    
    func backButtonPressed() {
        self.manager?.playBtnNoise();
        self.contentView.removeFromSuperview()
        self.manager?.scene = HelpScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)
    }
}

