//
//  PhysicsWorld.hpp
//  Prison_exe
//
//  Created by Ryan Dieno on 2018-03-07.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#ifndef PhysicsWorld_h
#define PhysicsWorld_h

#include "btBulletDynamicsCommon.h"
#import "PhysicsDebugDrawer.h"
#include "PhysicsInfo.h"
#include "PhysicsTags.h"

// container and setup for the physics world
class PhysicsWorld
{
public:
    PhysicsWorld();
    ~PhysicsWorld() {};
    
    btCollisionWorld* world;
    
    void update(float dt);
    void debugDraw();
    void AddCollisionObject(btCollisionObject* co);
    void RemoveCollisionObject(btCollisionObject* co);
    int CheckCollisionAndReturnTag();
    PhysicsInfo* CheckCollisionAndReturnPhysicsInfo();
private:
    // necessary setup objects for our physics world
    btBroadphaseInterface* broadphase;
    btDefaultCollisionConfiguration* collisionConfiguration;
    btCollisionDispatcher* dispatcher;
    btSequentialImpulseConstraintSolver* solver;
    
    // used to draw bounding boxes
    PhysicsDebugDrawer *debugDrawer;
};

#endif /* PhysicsWorld_h */
