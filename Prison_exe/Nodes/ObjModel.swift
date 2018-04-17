//
//  ObjModel.swift
//  Prison_exe
//
//  Created by Carl Kuang on 2018-02-28.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

class ObjModel : PhysicsNode, NSCopying {
    
    var indexList = [GLuint]()
    var vertexList = [Vertex]()
    var shader: ShaderProgram
    var tex: String
    
    init(indices: [GLuint], vertices: [Vertex], shader: ShaderProgram, texture: String)
    {
        self.indexList = indices
        self.vertexList = vertices
        self.shader = shader
        self.tex = texture
        
        super.init(name: "obj_" + texture, shaderProgram: shader, vertices: vertexList, indices: indexList)
        self.loadTexture(self.tex)
    }
    
    init(_ path: String, shader: ShaderProgram, texture: String = "dungeon_01.png", color: GLKVector4 = GLKVector4Make(1, 1, 1, 1))
    {
        // path: Bundle.main.path(forResource: "xxx", ofType: "obj")
        
        self.shader = shader
        self.tex = texture
        
        var triangleInt = [String : Int]()
        var triangleCount: Int = 0
        var v = [String]()
        var vt = [String]()
        var vn = [String]()
        
        do
        {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let lines = data.components(separatedBy: .newlines)
            
            for line in lines
            {
                // store all v, vt, vn into different list
                // for f's triple, store to hashmap
                // for each f line, get every triple from hashmap and put index into indices
                // then retrieve from from v, vt, vn and put into vertices
                
                // indices from triples start from 1
                // indices list itself should start from 0
                
                let parts = line.split(separator: " ", maxSplits: 1)
                if (line.hasPrefix("v "))
                {
                    v.append(String(parts[1]))
                }
                else if (line.hasPrefix("vt"))
                {
                    vt.append(String(parts[1]))
                }
                else if (line.hasPrefix("vn"))
                {
                    vn.append(String(parts[1]))
                }
                if (line.hasPrefix("f "))
                {
                    let faces = line.split(separator: " ")
                    for index in 1 ... faces.count - 1
                    {
                        let hash:String = String(faces[index])
                        if (triangleInt[hash] == nil) // does not contain
                        {
                            indexList.append(UInt32(triangleCount))
                            triangleInt[hash] = triangleCount
                            triangleCount += 1
                            
                            let faceIndices = hash.split(separator: "/")
                            let vIndex: Int = Int(String(faceIndices[0]))!
                            let vtIndex: Int = Int(String(faceIndices[1]))!
                            let vnIndex: Int = Int(String(faceIndices[2]))!
                            
                            let vString: String = v[vIndex - 1];
                            let vtString: String = vt[vtIndex - 1];
                            let vnString: String = vn[vnIndex - 1];
                            
                            let vParts = vString.split(separator: " ")
                            let vtParts = vtString.split(separator: " ")
                            let vnParts = vnString.split(separator: " ")
                            
                            let vert: Vertex = Vertex(
                                Float(String(vParts[0]))!, Float(String(vParts[1]))!, Float(String(vParts[2]))!,
                                0, 0, 0, 1,
                                Float(String(vtParts[0]))!, Float(String(vtParts[1]))!,
                                Float(String(vnParts[0]))!, Float(String(vnParts[1]))!, Float(String(vnParts[2]))!)
                            vertexList.append(vert)
                        }
                        else // contains
                        {
                            let index = triangleInt[hash]
                            indexList.append(UInt32(index!))
                        }
                    }
                }
            }
        } catch {}
        
        super.init(name: "obj_" + texture, shaderProgram: shader, vertices: vertexList, indices: indexList)
        self.loadTexture(self.tex)
        self.matColor = color
    }
    
    override func drawContent() {
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indexList.count), GLenum(GL_UNSIGNED_INT), nil)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ObjModel(indices: indexList, vertices: vertexList, shader: shader, texture: tex)
        return copy
    }
    
}


