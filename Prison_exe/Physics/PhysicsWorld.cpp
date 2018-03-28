//
//  PhysicsWorld.cpp
//  Prison_exe
//
//  Created by Ryan Dieno on 2018-03-07.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#include "PhysicsWorld.h"


PhysicsWorld::PhysicsWorld()
{
    /*broadphase = new btDbvtBroadphase();
    
    collisionConfiguration = new btDefaultCollisionConfiguration();
    dispatcher = new btCollisionDispatcher(collisionConfiguration);

    solver = new btSequentialImpulseConstraintSolver();
    
    world = new btDiscreteDynamicsWorld(dispatcher, broadphase, solver, collisionConfiguration);
    
    world->setGravity(btVector3(0, 0, 0));
    */
    
    // initalizes the physics world
    
    broadphase = new btDbvtBroadphase();
    
    collisionConfiguration = new btDefaultCollisionConfiguration();
    dispatcher = new btCollisionDispatcher(collisionConfiguration);
    
    //solver = new btSequentialImpulseConstraintSolver();

    world = new btCollisionWorld(dispatcher, broadphase, collisionConfiguration);
    
    
    // initialize debug drawer
    debugDrawer = new PhysicsDebugDrawer();
    world->setDebugDrawer(debugDrawer);
}

void PhysicsWorld::update(float dt)
{
    //world->stepSimulation(dt);
}

void PhysicsWorld::debugDraw()
{
    world->debugDrawWorld();
}

void PhysicsWorld::AddCollisionObject(btCollisionObject* co)
{
    world->addCollisionObject(co);
}

void PhysicsWorld::RemoveCollisionObject(btCollisionObject* co)
{
    world->removeCollisionObject(co);
}

// returns the tag of the colliding object or returns the no collision tag
int PhysicsWorld::CheckCollisionAndReturnTag()
{
    world->performDiscreteCollisionDetection();
    
    int tag = kNoCollisionTag;
    int numManifolds = world->getDispatcher()->getNumManifolds();
    for (int i=0;i<numManifolds;i++)
    {
        btPersistentManifold* contactManifold = world->getDispatcher()->getManifoldByIndexInternal(i);
        
        const btCollisionObject* obA = contactManifold->getBody0();
        const btCollisionObject* obB = contactManifold->getBody1();
        
        contactManifold->refreshContactPoints(obA->getWorldTransform(), obB->getWorldTransform());
        
        int numContacts = contactManifold->getNumContacts();
        if (numContacts > 0)
        {

            PhysicsInfo* pInfoA = (PhysicsInfo*)obA->getUserPointer();
            PhysicsInfo* pInfoB = (PhysicsInfo*)obB->getUserPointer();
            
            int pInfoATag = pInfoA->GetTag();
            int pInfoBTag = pInfoB->GetTag();

            if(pInfoATag != kPlayerTag) {
                tag = pInfoATag;
               // return tag;
            } else if(pInfoBTag != kPlayerTag) {
                tag = pInfoBTag;
                //return tag;
            }
        }
    }
    return tag;
}

// returns the colliding node or a null pointer for no collision
PhysicsInfo* PhysicsWorld::CheckCollisionAndReturnPhysicsInfo()
{
    world->performDiscreteCollisionDetection();
    
    int numManifolds = world->getDispatcher()->getNumManifolds();
    for (int i=0;i<numManifolds;i++)
    {
        btPersistentManifold* contactManifold = world->getDispatcher()->getManifoldByIndexInternal(i);
        
        const btCollisionObject* obA = contactManifold->getBody0();
        const btCollisionObject* obB = contactManifold->getBody1();
        
        contactManifold->refreshContactPoints(obA->getWorldTransform(), obB->getWorldTransform());
        
        int numContacts = contactManifold->getNumContacts();
        if (numContacts > 0)
        {
            PhysicsInfo* pInfoA = (PhysicsInfo*)obA->getUserPointer();
            PhysicsInfo* pInfoB = (PhysicsInfo*)obB->getUserPointer();
            
            int pInfoATag = pInfoA->GetTag();
            int pInfoBTag = pInfoB->GetTag();
            
            if(pInfoATag != kPlayerTag) {
                return pInfoA;
            } else if(pInfoBTag != kPlayerTag) {
                return pInfoB;
            }
        }
    }
    return nullptr;
}
