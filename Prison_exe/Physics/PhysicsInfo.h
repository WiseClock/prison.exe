//
//  PhysicsInfo.hpp
//  Prison_exe
//
//  Created by Ryan Dieno on 2018-03-07.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#ifndef PhysicsInfo_hpp
#define PhysicsInfo_hpp

#include "btBulletDynamicsCommon.h"

// container to hold bounding box for physics
class PhysicsInfo
{
public:
    PhysicsInfo() {};
    ~PhysicsInfo() {};
    
    void SetupCollisionBox(float width, float height, float depth);
    btCollisionObject* GetCollisionObject();
    
    void SetTag(int tag);
    int GetTag();

    void SetPosition(float x, float y, float z);
    void SetScale(float x, float y, float z);
    
    void* GetParent();
    void SetParent(void *parent);
    
private:
    btCollisionObject* collisionObject;
    btCollisionShape* shape;
    
    // used to identify the object
    int tag;
    
    // holds a reference to the physics info wrapper that holds this object
    void* parent;
    
    void CreateCollisionObject();
};


#endif /* PhysicsInfo_hpp */
