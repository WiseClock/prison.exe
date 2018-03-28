//
//  PhysicsDebugDrawer.h
//  Prison_exe
//
//  Created by Ryan Dieno on 2018-03-18.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#include "btBulletDynamicsCommon.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
//#import "Prison_exe-Swift.h"
//#import "LineShaderProgram.swift"

class PhysicsDebugDrawer : public btIDebugDraw {
public:
    GLuint VBO, VAO;
    /*void SetMatrices(GLKMatrix4 pViewMatrix, GLKMatrix4 pProjectionMatrix)
    {
        LineShaderProgram *lsp = [LineShaderProgram new];
        
        glUniformMatrix4fv(glGetUniformLocation(lsp.programHandle, "projection"), 1, GL_FALSE, pProjectionMatrix.array);
        glUniformMatrix4fv(glGetUniformLocation(lsp.programHandle, "view"), 1, GL_FALSE, pViewMatrix.array);
    }*/
    
    virtual void drawLine(const btVector3& from, const btVector3& to, const btVector3& color)
    {
        // Vertex data
        GLfloat points[12];
        
        points[0] = from.x();
        points[1] = from.y();
        points[2] = from.z();
        points[3] = color.x();
        points[4] = color.y();
        points[5] = color.z();
        
        points[6] = to.x();
        points[7] = to.y();
        points[8] = to.z();
        points[9] = color.x();
        points[10] = color.y();
        points[11] = color.z();
        
        glDeleteBuffers(1, &VBO);
        glDeleteVertexArraysOES(1, &VAO);
        glGenBuffers(1, &VBO);
        glGenVertexArraysOES(1, &VAO);
        glBindVertexArrayOES(VAO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(points), &points, GL_STATIC_DRAW);
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), 0);
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (GLvoid*)(3 * sizeof(GLfloat)));
        glBindVertexArrayOES(0);
        
        glBindVertexArrayOES(VAO);
        glDrawArrays(GL_LINES, 0, 2);
        glBindVertexArrayOES(0);
        
    }
    virtual void drawContactPoint(const btVector3 &, const btVector3 &, btScalar, int, const btVector3 &) {}
    virtual void reportErrorWarning(const char *) {}
    virtual void draw3dText(const btVector3 &, const char *) {}
    virtual void setDebugMode(int p) {
        m = p;
    }
    int getDebugMode(void) const { return 3; }
    int m;
};
