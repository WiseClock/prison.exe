//
//  ReadmeView.swift
//  Prison_exe
//
//  Created by Matt G on 2018-03-24.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import UIKit

class ReadmeView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var guideImage: UIImageView!
    var scene : ReadmeScene?
    var imageNumber : Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        commonInit();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        commonInit();
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ReadmeView", owner: self, options: nil);
        addSubview(contentView);
        contentView.frame = self.bounds;
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth];
        imageNumber = 0
        swapImage(image: imageNumber!)
    }
    
    private func swapImage(image: Int) {
        //this section will switch to the appropriate storyImage
        switch image {
        case 0:
            //first story image (placeholder)
            guideImage.image = UIImage(named: "dungeon_01.png")
            break;
        case 1:
            guideImage.image = UIImage(named: "title_placeholder.jpg")
            //second story image
            break
        default:
            //do nothing if out of bounds
            break
        }
    }
    
    @IBAction func lastButtonPressed(_ sender: Any) {
        //this will decrement the required story image and wrap around if below zero to max value for story images
        imageNumber = imageNumber! - 1
        //check here
        swapImage(image: imageNumber!)
        scene?.manager?.playBtnNoise();
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        //this will increment the required story image and wrap around if below zero to max value for story images
        imageNumber = imageNumber! + 1
        //check here
        swapImage(image: imageNumber!)
        scene?.manager?.playBtnNoise();
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        scene?.manager?.playBtnNoise();
        scene?.backButtonPressed()
    }
    

}
