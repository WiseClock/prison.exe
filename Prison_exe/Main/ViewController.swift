//
//  ViewController.swift
//
//  Created by Ryan Dieno on 2018-01-12.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import UIKit
import GLKit

class ViewController: GLKViewController {
    var glView : GLKView!
    var glkUpdater : GLKUpdater!
    var manager: GameManager!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredFramesPerSecond = 60
        self.view.backgroundColor = .clear
        
        // get reference to GLKView
        glView = self.view as! GLKView
        
        // setup updater delegate
        self.glkUpdater = GLKUpdater(glkViewController: self)
        self.delegate = self.glkUpdater
        
        // create our game manager and pass in the GLKView
        self.manager = GameManager.gameManager(of: self.glView)
        
        
        //self.manager.setPopEffect(file: "pop.wav")
        self.manager.setBtnNoise(file: "button.mp3")
        self.manager.setCollisionNoise(file: "collision.wav")
        self.manager.setSlideNoise(file: "slide.mp3")
        self.manager.setPowerupNoise(file: "power_up.wav")
        self.manager.setPowerDownNoise(file: "power_down.wav")
        self.manager.playBackgroundMusic(file: "bgm1.mp3")
        //self.manager.playBackgroundMusic(file: "bgm.mp3")
        
        self.manager.scorelabel = self.scoreLabel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*func update() {
        self.director.scene.updateWithDelta(self.timeSinceLastUpdate)
    }*/
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        // invoke the game managers render method which will render the current scene
        self.manager.render(with: GLKMatrix4Identity)
    }
    
    // Touch handling: pass these methods through to the manager
    
    @IBAction func touchGestureSwipedLeft(_ sender: UISwipeGestureRecognizer) {
        self.manager.scene.touchGestureSwipedLeft(sender)
    }
    
    @IBAction func touchGestureSwipedRight(_ sender: UISwipeGestureRecognizer) {
        self.manager.scene.touchGestureSwipedRight(sender)
    }
    
    @IBAction func touchGestureSwipedUp(_ sender: UISwipeGestureRecognizer) {
        self.manager.scene.touchGestureSwipedUp(sender)
    }
    
    @IBAction func touchGestureSwipedDown(_ sender: UISwipeGestureRecognizer) {
        self.manager.scene.touchGestureSwipedDown(sender)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.manager.scene.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.manager.scene.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.manager.scene.touchesEnded(touches, with: event)
    }
}

class GLKUpdater: NSObject, GLKViewControllerDelegate
{
    weak var glkViewController : ViewController!
    
    init(glkViewController : ViewController)
    {
        self.glkViewController = glkViewController
    }
    
    func glkViewControllerUpdate(_ controller: GLKViewController)
    {
        // update only the current scene and pass in delta time
        self.glkViewController.manager.scene.updateWithDelta(self.glkViewController.timeSinceLastUpdate)
    }
    
}
