//
//  ObstacleFactory.swift
//  Prison_exe
//
//  Created by Carl Kuang on 2018-03-01.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import Foundation

public class ObstacleBaby
{
    var obstacleModel: ObjModel
    var horizontal: [EObstaclePosition]
    var verticle: [EObstaclePosition]

    // container to hold physics bounding box
    //var physicsInfo : PhysicsInfoWrapper = PhysicsInfoWrapper()
    
    init(_ name: String, shader: ShaderProgram, horizontalPos: [EObstaclePosition], verticlePos: [EObstaclePosition])
    {
        obstacleModel = ObjModel.init(Bundle.main.path(forResource: name, ofType: "obj")!, shader: shader, texture: name + ".png")
        horizontal = horizontalPos
        verticle = verticlePos
    
        //self.physicsInfo.setup(withTag: obstacleTag, width: self.obstacleModel.width, height: self.obstacleModel.height, depth: self.obstacleModel.depth)
    }
    
    func getRandomHorizontal() -> EObstaclePosition
    {
        let rand: Int = Int(arc4random_uniform(UInt32(horizontal.count)))
        return horizontal[rand]
    }
    
    func getRandomVerticle() -> EObstaclePosition
    {
        let rand: Int = Int(arc4random_uniform(UInt32(verticle.count)))
        return verticle[rand]
    }
    
    func instantiate() -> ObjModel
    {
        return obstacleModel.copy() as! ObjModel
    }
    
    func updateWithDelta(_ dt: TimeInterval) {
        //self.physicsInfo.setPosition(self.obstacleModel.position)
    }
}
