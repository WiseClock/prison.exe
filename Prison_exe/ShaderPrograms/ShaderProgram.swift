//
//  ShaderProgram.swift
//
//  Created by Ryan Dieno on 2018-01-28.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import Foundation
import GLKit

// sets up and compiles our shader program
class ShaderProgram {
    var programHandle : GLuint = 0
    var modelViewMatrixUniform : Int32 = 0
    var projectionMatrixUniform : Int32 = 0
    var textureUniform : Int32 = 0
    var lightColorUniform : Int32 = 0
    var lightAmbientIntensityUniform : Int32 = 0
    var lightDiffuseIntensityUniform : Int32 = 0
    var lightDirectionUniform : Int32 = 0
    var matSpecularIntensityUniform : Int32 = 0
    var shininessUniform : Int32 = 0
    var matColorUniform : Int32 = 0

    var modelViewMatrix : GLKMatrix4 = GLKMatrix4Identity
    var projectionMatrix : GLKMatrix4 = GLKMatrix4Identity
    var matColor: GLKVector4 = GLKVector4Make(0, 0, 0, 0)
    
    var texture: GLuint = 0
    
    init(vertexShader: String, fragmentShader: String) {
        self.compile(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }
    
    //sets up default uniform properties
    func prepareToDraw() {
        glUseProgram(self.programHandle)
        
        glUniformMatrix4fv(self.modelViewMatrixUniform, 1, GLboolean(GL_FALSE), self.modelViewMatrix.array)
        glUniformMatrix4fv(self.projectionMatrixUniform, 1, GLboolean(GL_FALSE), self.projectionMatrix.array)
        
        glActiveTexture(GLenum(GL_TEXTURE1))
        glBindTexture(GLenum(GL_TEXTURE_2D), self.texture)
        glUniform1i(self.textureUniform, 1)
        
        glUniform3f(self.lightColorUniform, 1, 1, 1)
        let ambientIntensity : GLfloat = 0.1
        glUniform1f(self.lightAmbientIntensityUniform, ambientIntensity)
        
        let lightDirectionInitial : GLKVector3 = GLKVector3Normalize(GLKVector3(v: (0, 0, -1)))
        let lightRotation = GLKMatrix4RotateX(GLKMatrix4Identity, GLKMathDegreesToRadians(-45));
        var LightDirectionFinal = GLKMatrix4MultiplyVector3(lightRotation, lightDirectionInitial)
        
        glUniform3f(self.lightDirectionUniform, LightDirectionFinal.x, LightDirectionFinal.y, LightDirectionFinal.z)
        
        let diffuseIntensity : GLfloat = 0.7;
        glUniform1f(self.lightDiffuseIntensityUniform, diffuseIntensity)
        
        let specularIntensity : GLfloat = 1.0;
        glUniform1f(self.matSpecularIntensityUniform, specularIntensity)
        
        let shininess : GLfloat = 12.0;
        glUniform1f(self.shininessUniform, shininess)

        glUniform4f(self.matColorUniform, self.matColor.r, self.matColor.g, self.matColor.b, self.matColor.a);
    }
}

extension ShaderProgram {
    func compileShader(_ shaderName: String, shaderType: GLenum) -> GLuint {
        let path = Bundle.main.path(forResource: shaderName, ofType: nil)
        
        do {
            let shaderString = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue)
            let shaderHandle = glCreateShader(shaderType)
            var shaderStringLength : GLint = GLint(Int32(shaderString.length))
            var shaderCString = shaderString.utf8String
            glShaderSource(
                shaderHandle,
                GLsizei(1),
                &shaderCString,
                &shaderStringLength)
            
            glCompileShader(shaderHandle)
            var compileStatus : GLint = 0
            glGetShaderiv(shaderHandle, GLenum(GL_COMPILE_STATUS), &compileStatus)
            
            if compileStatus == GL_FALSE {
                var infoLength : GLsizei = 0
                let bufferLength : GLsizei = 1024
                glGetShaderiv(shaderHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
                
                let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
                var actualLength : GLsizei = 0
                
                glGetShaderInfoLog(shaderHandle, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info))
                NSLog(String(validatingUTF8: info)!)
                exit(1)
            }
            
            return shaderHandle
            
        } catch {
            exit(1)
        }
    }
    
    func compile(vertexShader: String, fragmentShader: String) {
        let vertexShaderName = self.compileShader(vertexShader, shaderType: GLenum(GL_VERTEX_SHADER))
        let fragmentShaderName = self.compileShader(fragmentShader, shaderType: GLenum(GL_FRAGMENT_SHADER))
        
        self.programHandle = glCreateProgram()
        glAttachShader(self.programHandle, vertexShaderName)
        glAttachShader(self.programHandle, fragmentShaderName)
        
        glBindAttribLocation(self.programHandle, VertexAttributes.position.rawValue, "a_Position") // bind the vertex to the a_Position attribute.
        glBindAttribLocation(self.programHandle, VertexAttributes.color.rawValue, "a_Color")
        glBindAttribLocation(self.programHandle, VertexAttributes.texCoord.rawValue, "a_TexCoord")
        glBindAttribLocation(self.programHandle, VertexAttributes.normal.rawValue, "a_Normal")
        glLinkProgram(self.programHandle)
        
        self.modelViewMatrixUniform = glGetUniformLocation(self.programHandle, "u_ModelViewMatrix")
        self.projectionMatrixUniform = glGetUniformLocation(self.programHandle, "u_ProjectionMatrix")
        self.textureUniform = glGetUniformLocation(self.programHandle, "u_Texture")
        self.lightColorUniform = glGetUniformLocation(self.programHandle, "u_Light.Color")
        self.lightAmbientIntensityUniform = glGetUniformLocation(self.programHandle, "u_Light.AmbientIntensity")
        self.lightDiffuseIntensityUniform = glGetUniformLocation(self.programHandle, "u_Light.DiffuseIntensity")
        self.lightDirectionUniform = glGetUniformLocation(self.programHandle, "u_Light.Direction")
        self.matSpecularIntensityUniform = glGetUniformLocation(self.programHandle, "u_MatSpecularIntensity")
        self.shininessUniform = glGetUniformLocation(self.programHandle, "u_Shininess")
        self.matColorUniform = glGetUniformLocation(self.programHandle, "u_MatColor")
        
        var linkStatus : GLint = 0
        glGetProgramiv(self.programHandle, GLenum(GL_LINK_STATUS), &linkStatus)
        if linkStatus == GL_FALSE {
            var infoLength : GLsizei = 0
            let bufferLength : GLsizei = 1024
            glGetProgramiv(self.programHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
            
            let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
            var actualLength : GLsizei = 0
            
            glGetProgramInfoLog(self.programHandle, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info))
            NSLog(String(validatingUTF8: info)!)
            exit(1)
        }
    }
}

