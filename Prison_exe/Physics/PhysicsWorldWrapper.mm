//
//  PhysicsWorldWrapper.m
//  Prison_exe
//
//  Created by Ryan Dieno on 2018-03-07.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "PhysicsWorldWrapper.h"
#import "PhysicsWorld.h"
//#import "PhysicsInfo.h"
#import "PhysicsInfoWrapperAdditions.h"
//#include "Prison_exe-Swift.h"

struct PhysicsWorldObject {
    PhysicsWorld pWorld;
};

@implementation PhysicsWorldWrapper

- (id)init
{
    if((self = [super init])) {
        physicsWorldObj = new PhysicsWorldObject;
    }
    return self;
}

-(void)update:(float) dt
{
    physicsWorldObj->pWorld.update(dt);
}

-(void)debugDraw
{
    physicsWorldObj->pWorld.debugDraw();
}

-(void)addCollisionObject:(PhysicsInfoWrapper *) pInfoWrapper
{
    physicsWorldObj->pWorld.AddCollisionObject([pInfoWrapper getPhysicsInfo].GetCollisionObject());
}

-(void)removeCollisionObject:(PhysicsInfoWrapper *) pInfoWrapper
{
    physicsWorldObj->pWorld.RemoveCollisionObject([pInfoWrapper getPhysicsInfo].GetCollisionObject());
}

-(int)checkCollisionAndReturnTag {
    return physicsWorldObj->pWorld.CheckCollisionAndReturnTag();
}

-(PhysicsNode *)checkCollisionAndReturnNode {
    PhysicsInfo *pi = physicsWorldObj->pWorld.CheckCollisionAndReturnPhysicsInfo();
    if(pi != nil) {
        PhysicsInfoWrapper *piw = (__bridge PhysicsInfoWrapper *) pi->GetParent();
        return piw.owner;
    } else {
        return nullptr;
    }
}



@end
