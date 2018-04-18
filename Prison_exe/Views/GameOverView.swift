//
//  GameOverView.swift
//  Prison_exe
//
//  Created by Matt G on 2018-02-27.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import UIKit

class GameOverView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    var scene : GameOverScene?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        commonInit();
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        commonInit();
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GameOverView", owner: self, options: nil);
        addSubview(contentView);
        contentView.frame = self.bounds;
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth];
        scene?.manager?.playBackgroundMusic(file: "game_over.mp3")
    }

    @IBAction func saveScoreButtonPressed(_ sender: Any) {
        scene?.saveScoreButtonPressed()
    }
    
    @IBAction func playAgainButtonPressed(_ sender: Any) {
        scene?.playAgainButtonPressed()
    }
    
    @IBAction func highScoresButtonPressed(_ sender: Any) {
        scene?.highScoresButtonPressed()
    }
    
    @IBAction func mainMenuButtonPressed(_ sender: Any) {
        scene?.mainMenuButtonPressed()
    }
}
