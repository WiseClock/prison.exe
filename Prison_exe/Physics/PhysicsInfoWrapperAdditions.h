//
//  PhysicsInfoWrapperAdditions.h
//  Prison_exe
//
//  Created by Ryan Dieno on 2018-03-09.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#ifndef PhysicsInfoWrapperAdditions_h
#define PhysicsInfoWrapperAdditions_h

#import "PhysicsInfo.h"

// class extension so we can return c++ classes within objective-c++

@interface PhysicsInfoWrapper (PhysicsInfoWrapperAdditions)
-(PhysicsInfo)getPhysicsInfo;
@end

#endif /* PhysicsInfoWrapperAdditions_h */
