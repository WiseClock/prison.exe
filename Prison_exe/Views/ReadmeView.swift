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
    var readmeImages :Int?
    
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
        readmeImages = 9
        swapImage(image: imageNumber!)
    }
    
    private func swapImage(image: Int) {
        //this section will switch to the appropriate storyImage
        switch image {
        case 0:
            //first readme image
            guideImage.image = UIImage(named: "readme1.png")
            break;
        case 1:
            guideImage.image = UIImage(named: "readme2.png")
            //second readme image
            break
        case 2:
            guideImage.image = UIImage(named: "readme3.png")
            //third story image
            break
        case 3:
            guideImage.image = UIImage(named: "readme4.png")
            //fourth readme image
            break
        case 4:
            guideImage.image = UIImage(named: "readme5.png")
            //fifth readme image
            break
        case 5:
            guideImage.image = UIImage(named: "readme6.png")
            //sixth readme image
            break
        case 6:
            guideImage.image = UIImage(named: "readme7.png")
            //seventh readme image
            break
        case 7:
            guideImage.image = UIImage(named: "readme8.png")
            //eigth readme image
            break
        case 8:
            guideImage.image = UIImage(named: "readme9.png")
            //ninth readme image
            break
        case 9:
            guideImage.image = UIImage(named: "readme10.png")
            //tenth readme image
            break
        default:
            //do nothing if out of bounds
            break
        }
    }
    
    @IBAction func lastButtonPressed(_ sender: Any) {
        //this will decrement the required story image and wrap around if below zero to max value for story images
        imageNumber! = imageNumber! - 1
        if (imageNumber! < 0 ) {
            imageNumber! = readmeImages!
        }
        //check here
        swapImage(image: imageNumber!)
        scene?.manager?.playBtnNoise();
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        //this will increment the required story image and wrap around if below zero to max value for story images
        imageNumber! = imageNumber! + 1
        if (imageNumber! > readmeImages! ) {
            imageNumber! = 0
        }
        //check here
        swapImage(image: imageNumber!)
        scene?.manager?.playBtnNoise();
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        scene?.manager?.playBtnNoise();
        scene?.backButtonPressed()
    }
    

}
