//
//  PhysicsWorldWrapper.h
//  Prison_exe
//
//  Created by Ryan Dieno on 2018-03-07.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "PhysicsInfoWrapper.h"

@class PhysicsNode;

struct PhysicsWorldObject;

// interface to our physics world for use in swift code
@interface PhysicsWorldWrapper : NSObject
{
    @private
    struct PhysicsWorldObject *physicsWorldObj;
}

-(void)update:(float) dt;
-(void)debugDraw;
-(void)addCollisionObject:(PhysicsInfoWrapper *) pInfoWrapper;
-(void)removeCollisionObject:(PhysicsInfoWrapper *) pInfoWrapper;
-(int)checkCollisionAndReturnTag;
-(PhysicsNode *)checkCollisionAndReturnNode;

@end
