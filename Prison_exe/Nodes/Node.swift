//
//  Node.swift
//
//  Created by Ryan Dieno on 2018-01-28.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

// base node class that all game objects and scene will inherit from
// includes size, position, scale, rotation as well as draw and update methods
class Node {
    static var idCounter : Int = 0
    var id: Int = 0
    var shaderProgram : ShaderProgram
    var name : String
    var vertices : [Vertex]
    var indices : [GLuint]
    
    var vao: GLuint = 0
    var vertexBuffer : GLuint = 0
    var indexBuffer : GLuint = 0
    var texture: GLuint = 0
    
    var position : GLKVector3 = GLKVector3(v: (0.0, 0.0, 0.0))
    
    var positionX : Float = 0.0
    var positionY : Float = 0.0
    var positionZ : Float = 0.0
    
    var rotationX : Float = 0.0
    var rotationY : Float = 0.0
    var rotationZ : Float = 0.0
    
    var scale : Float = 1.0
    var scaleX : Float = 1.0
    var scaleY : Float = 1.0
    var scaleZ : Float = 1.0
    
    var width : Float = 0.0
    var height : Float = 0.0
    var depth : Float = 0.0
    
    var rotating : Bool = false
    
    var matColor: GLKVector4 = GLKVector4Make(1, 1, 1, 1)
    
    var parent: Node?
    var children : [Node] = [Node]()
    
    init(name: String, shaderProgram: ShaderProgram, vertices: [Vertex] = [], indices: [GLuint] = []) {
        self.name = name;
        self.shaderProgram = shaderProgram
        self.vertices = vertices
        self.indices = indices
        
        self.setupVertexBuffer()
        self.computeVolume()
        
        self.id = self.createID()
    }
    
    // clean up textures, vertex and index info
    deinit {
        glDeleteTextures(1, &self.texture);
        glDeleteBuffers(1, &self.vertexBuffer)
        glDeleteBuffers(1, &self.indexBuffer)
        glDeleteVertexArraysOES(1, &self.vao);
    }
    
    // get the nodes current model matrix
    var modelMatrix: GLKMatrix4 {
        var modelMatrix : GLKMatrix4 = GLKMatrix4Identity
        modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, self.position.z)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationX, 1, 0, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationY, 0, 1, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationZ, 0, 0, 1)
        modelMatrix = GLKMatrix4Scale(modelMatrix, self.scaleX * self.scale, self.scaleY * self.scale, self.scaleZ * self.scale)
        return modelMatrix
    }
    
    // renders object and all children with the loaded shader program
    /*func render(with parentModelViewMatrix: GLKMatrix4) {
        let modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, self.modelMatrix)
        
        for child in self.children { child.render(with: modelViewMatrix) }
        
        self.shaderProgram.modelViewMatrix = modelViewMatrix
        self.shaderProgram.texture = self.texture
        self.shaderProgram.matColor = self.matColor
        self.shaderProgram.prepareToDraw()
        
        glBindVertexArrayOES(self.vao)
        
        self.drawContent()

        glBindVertexArrayOES(0)
    }*/

    func render(with parentModelViewMatrix: GLKMatrix4) {
        let modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, self.modelMatrix)
        
        self.shaderProgram.modelViewMatrix = modelViewMatrix
        self.shaderProgram.texture = self.texture
        self.shaderProgram.matColor = self.matColor
        self.shaderProgram.prepareToDraw()
        
        // draw the object itself first so we have the blend effect
        if (!(self is Player))
        {
            glBindVertexArrayOES(self.vao)
            self.drawContent()
            glBindVertexArrayOES(0)
        }
        
        // last in first out to blend correctly
        for child in self.children.reversed() { child.render(with: modelViewMatrix) }
    }
    
    // override this function with the relavant drawing method (drawArrays or drawElements)
    func drawContent() { }
    
    func updateWithDelta(_ dt: TimeInterval) {
        self.positionX = self.position.x
        self.positionY = self.position.y
        self.positionZ = self.position.z
        
        
        // call update on all of the node's children
        for child in self.children {
            child.updateWithDelta(dt)
        }

    }
    
    // loads texture from file
    func loadTexture(_ filename: String) {
        let path = Bundle.main.path(forResource: filename, ofType: nil)
        if (path == nil)
        {
            return;
        }
        let option = [ GLKTextureLoaderOriginBottomLeft: true]
        do {
            let info = try GLKTextureLoader.texture(withContentsOfFile: path!, options: option as [String : NSNumber]?)
            self.texture = info.name
        } catch {
            
        }
    }
    
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: n)
    }
    
    // initializes vertex buffer with nodes custom vertex information
    func setupVertexBuffer() {
        // generate and bind vertex array object
        glGenVertexArraysOES(1, &self.vao)
        glBindVertexArrayOES(self.vao)
        
        // Generate vertex buffer
        glGenBuffers(GLsizei(1), &self.vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.vertexBuffer)
        let vertexCount = self.vertices.count
        let vertexSize = MemoryLayout<Vertex>.size
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertexCount * vertexSize, self.vertices, GLenum(GL_STATIC_DRAW))
        
        // generate, bind and buffer vertex index array buffer object
        glGenBuffers(GLsizei(1), &self.indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), self.indexBuffer)
        let indicesCount = self.indices.count
        let indicesSize = MemoryLayout<GLuint>.size
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indicesCount * indicesSize, self.indices, GLenum(GL_STATIC_DRAW))
        
        // Enable Vertex Attributes
        glEnableVertexAttribArray(VertexAttributes.position.rawValue)
        glVertexAttribPointer(
            VertexAttributes.position.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size),
            BUFFER_OFFSET(0))
        
        glEnableVertexAttribArray(VertexAttributes.color.rawValue)
        glVertexAttribPointer(
            VertexAttributes.color.rawValue,
            4,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size),
            BUFFER_OFFSET(3 * MemoryLayout<GLfloat>.size))
        
        glEnableVertexAttribArray(VertexAttributes.texCoord.rawValue)
        glVertexAttribPointer(
            VertexAttributes.texCoord.rawValue,
            2,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET((3+4) * MemoryLayout<GLfloat>.size))
        
        glEnableVertexAttribArray(VertexAttributes.normal.rawValue)
        glVertexAttribPointer(
            VertexAttributes.normal.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET((3+4+2) * MemoryLayout<GLfloat>.size))
        
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    func touchGestureSwipedLeft(_ sender: UISwipeGestureRecognizer) {}
    func touchGestureSwipedRight(_ sender: UISwipeGestureRecognizer) {}
    func touchGestureSwipedUp(_ sender: UISwipeGestureRecognizer) {}
    func touchGestureSwipedDown(_ sender: UISwipeGestureRecognizer) {}
    
    /*
    // creates a bounding box based on the node's width and height
    func boundingBoxWithModelViewMatrix(parentModelViewMatrix: GLKMatrix4) -> CGRect {
        let modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, self.modelMatrix)
        
        let preLowerLeft = GLKVector4Make(-self.width / 2, -self.height / 2, 0, 1)
        let lowerLeft = GLKMatrix4MultiplyVector4(modelViewMatrix, preLowerLeft)
        
        let preUpperRight = GLKVector4Make(self.width / 2, self.height / 2, 0, 1)
        let upperRight = GLKMatrix4MultiplyVector4(modelViewMatrix, preUpperRight)
        
        let boundingBox = CGRect(x: CGFloat(lowerLeft.x),
                                 y: CGFloat(lowerLeft.y),
                                 width: CGFloat(upperRight.x - lowerLeft.x),
                                 height: CGFloat(upperRight.y - lowerLeft.y))
        return boundingBox
    }
    */
    
    func computeWidth() {
        let xs = self.vertices.map{ $0.x }
        let minX = xs.min() ?? 0
        let maxX = xs.max() ?? 0
        self.width = (maxX - minX) * self.scaleX * self.scale
    }
    
    func computeHeight() {
        let ys = self.vertices.map{ $0.y }
        let minY = ys.min() ?? 0
        let maxY = ys.max() ?? 0
        self.height = (maxY - minY) * self.scaleY * self.scale
    }
    
    func computeDepth() {
        let zs = self.vertices.map{ $0.z }
        let minZ = zs.min() ?? 0
        let maxZ = zs.max() ?? 0
        self.depth = (maxZ - minZ) * self.scaleZ * self.scale
    }
    
    func computeVolume() {
        self.computeWidth()
        self.computeHeight()
        self.computeDepth()
    }
    
    func createID() -> Int {
        Node.idCounter += 1;
        return Node.idCounter
    }
}
