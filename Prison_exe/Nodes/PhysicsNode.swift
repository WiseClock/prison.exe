//
//  PhysicsNode.swift
//  Prison_exe
//
//  Created by Ryan Dieno on 2018-03-17.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import Foundation

class PhysicsNode: Node {
    // container to hold physics bounding box
    var physicsInfo : PhysicsInfoWrapper = PhysicsInfoWrapper()
    
    func setupPhysicsInfo(tag: Int32) {
        self.physicsInfo.setup(withTag: tag, width: self.width / 2.0, height: self.height / 2.0, depth: self.depth / 2.0)
        self.physicsInfo.owner = self
    }
    
    override func updateWithDelta(_ dt: TimeInterval) {
        // call update on all of the node's children
        for child in self.children {
            child.updateWithDelta(dt)
        }
        
        var worldPos : GLKVector3 = self.position
        var worldScale : GLKVector3 = GLKVector3Make(self.scaleX * self.scale, self.scaleY * self.scale, self.scaleZ * self.scale)
        
        var myParent : Node? = self.parent

        while myParent != nil {
            var parentPos : GLKVector3 = myParent!.position
            
            worldPos = GLKVector3Make(worldPos.x * (myParent!.scaleX * myParent!.scale) + parentPos.x,
                                      worldPos.y * (myParent!.scaleY * myParent!.scale) + parentPos.y,
                                      worldPos.z * (myParent!.scaleZ * myParent!.scale) + parentPos.z)
            
            var parentScale : GLKVector3 = GLKVector3Make(myParent!.scaleX * myParent!.scale,
                                                          myParent!.scaleY * myParent!.scale,
                                                          myParent!.scaleZ * myParent!.scale)
            
            worldScale = GLKVector3Make(worldScale.x * parentScale.x,
                                        worldScale.y * parentScale.y,
                                        worldScale.y * parentScale.y)
            
            myParent = myParent?.parent
        }

        
        // sync position and scale with physics bounding box
        self.physicsInfo.setPosition(worldPos)
        self.physicsInfo.setScaleWithX(worldScale.x, y: worldScale.y, z: worldScale.z)
    }
}
