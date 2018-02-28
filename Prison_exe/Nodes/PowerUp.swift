//
//  PowerUp.swift
//  Prison_exe
//
//  Created by Robert Broyles on 2018-02-27.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit
import UIKit

// a single power-up: bonus points
class PowerUp : Cube {
    // check if it is touched
    var isTouched : Bool
    
    // keeps track of which lane the power-up is currently in
    var currentLane : Lane
    
    // saves the initial position in our scenes coordinate system
    var initialPosition: GLKVector3
    
    init(shader: ShaderProgram, levelWidth: Float, initialPosition: GLKVector3) {
        self.isTouched = false;
        
        // set lane
        self.currentLane = Lane.middle;
        self.initialPosition = initialPosition;
        
        super.init(shader: shader)
        
        // set color and size of power-up
        self.matColor = GLKVector4Make(0, 1, 0, 1)
        self.scaleY = 2.0
        self.scaleX = 2.0
        self.scaleZ = 2.0
        
    }
    
    // Still need to add the function to do the power up
}

