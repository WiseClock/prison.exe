//
//  PhysicsInfoWrapper.m
//  Prison_exe
//
//  Created by Ryan Dieno on 2018-03-08.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "PhysicsInfoWrapper.h"
#import "PhysicsInfo.h"

struct PhysicsInfoObject {
    PhysicsInfo pInfo;
};

@implementation PhysicsInfoWrapper

- (id)init
{
    if((self = [super init])) {
        physicsInfoObj = new PhysicsInfoObject;
    }
    return self;
}

// sets up bounding box, tag and passes reference to our physics info object as parent
-(void)setupWithTag:(int)tag width:(float)width height:(float)height depth:(float) depth
{
    physicsInfoObj->pInfo.SetTag(tag);
    physicsInfoObj->pInfo.SetupCollisionBox(width, height, depth);
    physicsInfoObj->pInfo.SetParent((__bridge void*)self);
}

-(PhysicsInfo)getPhysicsInfo
{
    return physicsInfoObj->pInfo;
}

-(int)getTag
{
    return physicsInfoObj->pInfo.GetTag();
}

-(void)setPosition:(GLKVector3) position
{
    physicsInfoObj->pInfo.SetPosition(position.x, position.y, position.z);
}

-(void)setScaleWithX:(float) x Y:(float) y Z:(float) z
{
    physicsInfoObj->pInfo.SetScale(x, y, z);
}

@end

