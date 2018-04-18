//
//  GameOverScene.swift
//
//  Created by Ryan Dieno on 2018-02-19.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

class HighScoresScene: Scene {
    var contentView: HighScoresView!
    
    var nameLabel1: UILabel!
    var scoreLabel1: UILabel!
    var nameLabel2: UILabel!
    var scoreLabel2: UILabel!
    var nameLabel3: UILabel!
    var scoreLabel3: UILabel!
    var nameLabel4: UILabel!
    var scoreLabel4: UILabel!
    var nameLabel5: UILabel!
    var scoreLabel5: UILabel!
    
    init(shaderProgram: ShaderProgram, view: GLKView) {
        super.init(name: "HighScoresScene", shaderProgram: shaderProgram)
        self.contentView = HighScoresView.init(frame: view.frame)
        self.contentView.scene = self
        view.addSubview(self.contentView)

        self.nameLabel1 = self.contentView.nameLabel1
        self.nameLabel2 = self.contentView.nameLabel2
        self.nameLabel3 = self.contentView.nameLabel3
        self.nameLabel4 = self.contentView.nameLabel4
        self.nameLabel5 = self.contentView.nameLabel5
        self.scoreLabel1 = self.contentView.scoreLabel1
        self.scoreLabel2 = self.contentView.scoreLabel2
        self.scoreLabel3 = self.contentView.scoreLabel3
        self.scoreLabel4 = self.contentView.scoreLabel4
        self.scoreLabel5 = self.contentView.scoreLabel5
    }
    
    func playGameButtonPressed() {
        self.contentView.removeFromSuperview()
        //self.manager?.scene = GameScene.init(shaderProgram: (self.manager?.shaderProgram)!)
        
        let ps : PrologueScene = PrologueScene.init(shaderProgram: (self.manager?.shaderProgram)!)
        self.manager?.scene = ps;
        
        self.manager?.playBtnNoise();
        self.manager?.stopBackgroundMusic()

    }
    
    func mainMenuButtonPressed() {
        self.contentView.removeFromSuperview()
        self.manager?.scene = MainMenuScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)
        self.manager?.playBtnNoise();
    }
    
    func loadHighScores() {
        
        var index: Int = 0
        
        for(dict) in (self.manager?.highScores.highScores)! {
            let name: String = dict["name"] as! String
            let score: Int = dict["score"] as! Int
            
            switch(index) {
            case 0:
                self.nameLabel1.text = name
                self.scoreLabel1.text = String(score)
            case 1:
                self.nameLabel2.text = name
                self.scoreLabel2.text = String(score)
            case 2:
                self.nameLabel3.text = name
                self.scoreLabel3.text = String(score)
            case 3:
                self.nameLabel4.text = name
                self.scoreLabel4.text = String(score)
            case 4:
                self.nameLabel5.text = name
                self.scoreLabel5.text = String(score)
            default:
            break;
            }
            
            index += 1
        }
        
    }
}
