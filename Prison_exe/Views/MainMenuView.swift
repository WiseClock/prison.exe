//
//  MainMenuView.swift
//  Prison_exe
//
//  Created by Matt G on 2018-02-27.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import UIKit

class MainMenuView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleImage: UIImageView!
    var scene : MainMenuScene?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MainMenuView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        scene?.playButtonPressed()
    }
    
    @IBAction func highScoresButtonPressed(_ sender: Any) {
        scene?.highScoresButtonPressed()
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        scene?.helpButtonPressed()
    }
    
    
}
