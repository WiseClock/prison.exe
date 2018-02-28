//
//  RDTestScene.swift
//  Mushroom
//
//  Created by Ryan Dieno on 2018-02-08.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

class TestScene : Scene {
    
    var cube: Cube

    init(shaderProgram: ShaderProgram) {
        self.cube = Cube(shader: shaderProgram)
        self.cube.rotating = true
        self.cube.position = GLKVector3Make(0, 2, 0)
        self.cube.scale = 2
        super.init(name: "RDTestScene", shaderProgram: shaderProgram)
        
        self.children.append(cube)
        
        self.position = GLKVector3Make(0, 0, -5);
        
    }

    override func updateWithDelta(_ dt: TimeInterval) {
        super.updateWithDelta(dt)
    }
}
