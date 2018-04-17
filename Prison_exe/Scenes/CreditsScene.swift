//
//  CreditsScene.swift
//  Prison_exe
//
//  Created by Matt G on 2018-03-24.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

class CreditsScene: Scene {
    var contentView: CreditsView!
    
    init(shaderProgram: ShaderProgram, view: GLKView) {
        super.init(name: "CreditsScene", shaderProgram: shaderProgram)
        self.contentView = CreditsView.init(frame: view.frame)
        self.contentView.scene = self
        view.addSubview(self.contentView)
    }
    
    func backButtonPressed() {
        self.manager?.playBtnNoise();
        self.contentView.removeFromSuperview()
        self.manager?.scene = HelpScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)
    }
}
