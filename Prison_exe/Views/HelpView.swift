//
//  HelpView.swift
//  Prison_exe
//
//  Created by Matt G on 2018-02-27.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import UIKit

class HelpView: UIView {

    @IBOutlet var contentView: UIView!
    var scene : HelpScene?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        commonInit();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        commonInit();
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HelpView", owner: self, options: nil);
        addSubview(contentView);
        contentView.frame = self.bounds;
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth];
    }
    
    @IBAction func howToPlayButtonPressed(_ sender: Any) {
        scene?.howToPlayButtonPressed()
    }
    
    @IBAction func storylineButtonPressed(_ sender: Any) {
        scene?.storylineButtonPressed()
    }
    
    @IBAction func creditsButtonPressed(_ sender: Any) {
        scene?.creditsButtonPressed()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        scene?.backButtonPressed()
    }
    
}
