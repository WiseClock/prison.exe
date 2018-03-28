//
//  PhysicsInfo.cpp
//  Prison_exe
//
//  Created by Ryan Dieno on 2018-03-07.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#include "PhysicsInfo.h"

// creates a bounding box for physics calculations
void PhysicsInfo::SetupCollisionBox(float width, float height, float depth)
{
    shape = new btBoxShape(btVector3(width, height, depth));
    CreateCollisionObject();
}

btCollisionObject* PhysicsInfo::GetCollisionObject()
{
    return collisionObject;
}

void PhysicsInfo::SetTag(int tag)
{
    this->tag = tag;
}

int PhysicsInfo::GetTag()
{
    return tag;
}

// updates current position of collision object
void PhysicsInfo::SetPosition(float x, float y, float z)
{
    if(collisionObject) {
        btTransform trans = collisionObject->getWorldTransform();
        trans.setOrigin(btVector3(x, y, z));
        collisionObject->setWorldTransform(trans);
    }
}

// updates current scale of collision object
void PhysicsInfo::SetScale(float x, float y, float z)
{
    collisionObject->getCollisionShape()->setLocalScaling(btVector3(x, y, z));
}

void* PhysicsInfo::GetParent()
{
    return this->parent;
}

void PhysicsInfo::SetParent(void *parent)
{
    this->parent = parent;
}

// creates a collision object using the bounding box
void PhysicsInfo::CreateCollisionObject()
{
    collisionObject = new btCollisionObject();
    collisionObject->setUserPointer((void*) this);
    collisionObject->setCollisionShape(shape);
}
