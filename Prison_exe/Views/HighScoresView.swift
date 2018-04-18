//
//  GameOverView.swift
//  Prison_exe
//
//  Created by Matt G on 2018-02-27.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import UIKit

class HighScoresView: UIView {

    @IBOutlet var contentView: UIView!
    var scene : HighScoresScene?
    
    @IBOutlet weak var nameLabel1: UILabel!
    @IBOutlet weak var scoreLabel1: UILabel!
    @IBOutlet weak var nameLabel2: UILabel!
    @IBOutlet weak var scoreLabel2: UILabel!
    @IBOutlet weak var nameLabel3: UILabel!
    @IBOutlet weak var scoreLabel3: UILabel!
    @IBOutlet weak var nameLabel4: UILabel!
    @IBOutlet weak var scoreLabel4: UILabel!
    @IBOutlet weak var nameLabel5: UILabel!
    @IBOutlet weak var scoreLabel5: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        commonInit();
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        commonInit();
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HighScoresView", owner: self, options: nil);
        addSubview(contentView);
        contentView.frame = self.bounds;
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth];
    }

    @IBAction func playGameButtonPressed(_ sender: Any) {
        scene?.playGameButtonPressed()
    }

    @IBAction func mainMenuButtonPressed(_ sender: Any) {
        scene?.mainMenuButtonPressed()
    }
    
}
