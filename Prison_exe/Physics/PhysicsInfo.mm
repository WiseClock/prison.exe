//
//  PhysicsInfo.cpp
//  Prison_exe
//
//  Created by Ryan Dieno on 2018-03-07.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#include "PhysicsInfo.h"

void PhysicsInfo::SetTag(int tag)
{
    this->tag = tag;
}

int PhysicsInfo::GetTag()
{
    return tag;
}

btCollisionObject* PhysicsInfo::GetCollisionObject()
{
    return collisionObject;
}

void PhysicsInfo::SetupCollisionBox(float width, float height, float depth)
{
    shape = new btBoxShape(btVector3(width, height, depth));
    CreateCollisionObject();
}

void PhysicsInfo::CreateCollisionObject()
{
    collisionObject = new btCollisionObject();
    collisionObject->setUserPointer((void*) this);
    //collisionObject->setFriction(0.5f);
    //collisionObject->setRestitution(1.0f);
    collisionObject->setCollisionShape(shape);
}

void PhysicsInfo::SetPosition(float x, float y, float z)
{
    if(collisionObject) {
        btTransform trans = collisionObject->getWorldTransform();
        trans.setOrigin(btVector3(x, y, z));
        collisionObject->setWorldTransform(trans);
    }
}

void PhysicsInfo::SetScale(float x, float y, float z)
{
    collisionObject->getCollisionShape()->setLocalScaling(btVector3(x, y, z));
}

