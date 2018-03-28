//
//  PhysicsInfoWrapper.h
//  Prison_exe
//
//  Created by Ryan Dieno on 2018-03-08.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class PhysicsNode;

struct PhysicsInfoObject;

// interface to our physics info object for use in swift code
@interface PhysicsInfoWrapper : NSObject
{
    @private
    struct PhysicsInfoObject *physicsInfoObj;
}

// holds a reference to the physics node that owns this object
@property (nonatomic, strong) PhysicsNode *owner;

-(void)setupWithTag:(int)tag width:(float)width height:(float)height depth:(float) depth;
-(int)getTag;
-(void)setPosition:(GLKVector3) position;
-(void)setScaleWithX:(float) x Y:(float) y Z:(float) z;

@end

