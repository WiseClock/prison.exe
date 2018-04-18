//
//  GameOverScene.swift
//
//  Created by Ryan Dieno on 2018-02-19.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

class GameOverScene: Scene {
    var contentView: GameOverView!
    var scoreLabel: UILabel!
    var nameText: UILabel!
    var nameTextField: UITextField!
    var currentScore: Int!
    
    init(shaderProgram: ShaderProgram, view: GLKView, score: Int) {
        super.init(name: "GameOverScene", shaderProgram: shaderProgram)
        self.contentView = GameOverView.init(frame: view.frame)
        self.contentView.scene = self
        view.addSubview(self.contentView)
        self.manager?.scorelabel?.isHidden = true
        self.scoreLabel = self.contentView.scoreLabel
        self.currentScore = score
        self.setScore(score: self.currentScore)
        self.nameTextField = self.contentView.nameTextField
    }
    
    func setScore(score: Int) {
        self.scoreLabel.text = "Score: " + String(self.currentScore)
    }
    
    func playAgainButtonPressed() {
        self.contentView.removeFromSuperview()
        //self.manager?.scene = GameScene.init(shaderProgram: (self.manager?.shaderProgram)!)
        
        let ps : PrologueScene = PrologueScene.init(shaderProgram: (self.manager?.shaderProgram)!)
        self.manager?.scene = ps;
        
        // resets score if a previously game had been played
        self.manager?.updateScore(score: 0)
        
        self.manager?.playBtnNoise();
        self.manager?.stopBackgroundMusic()
        self.manager?.scorelabel?.isHidden = true
        //self.manager?.playBackgroundMusic(file: "game.mp3")
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
    
    func saveScoreButtonPressed() {
        
        if(self.nameTextField.text != nil) {
            self.contentView.removeFromSuperview()
            
            self.manager?.highScores.inputHighScore(score: self.currentScore, name: self.nameTextField.text!)
            self.manager?.highScores.saveHighScores()
            
            let hss = HighScoresScene.init(shaderProgram: (self.manager?.shaderProgram)!, view: (self.manager?.glkView)!)
            self.manager?.scene = hss
            hss.loadHighScores()
            
            self.manager?.playBtnNoise();
            
        }
    }
}
