//
//  CreditsView.swift
//  Prison_exe
//
//  Created by Matt G on 2018-03-24.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import UIKit

class CreditsView: UIView {

    @IBOutlet var contentView: UIView!
    var scene : CreditsScene?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        commonInit();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        commonInit();
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CreditsView", owner: self, options: nil);
        addSubview(contentView);
        contentView.frame = self.bounds;
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth];
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        scene?.backButtonPressed()
    }
    
}
