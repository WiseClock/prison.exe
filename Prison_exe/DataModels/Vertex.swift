//
//  Vertex.swift
//
//  Created by Ryan Dieno on 2018-01-28.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import Foundation
import GLKit

enum VertexAttributes : GLuint {
    case position = 0
    case color = 1
    case texCoord = 2
    case normal = 3
}

// Custom class to hold vertex information
struct Vertex {
    // Position
    var x : GLfloat = 0.0
    var y : GLfloat = 0.0
    var z : GLfloat = 0.0
    
    // Color
    var r : GLfloat = 0.0
    var g : GLfloat = 0.0
    var b : GLfloat = 0.0
    var a : GLfloat = 1.0
    
    // Texture Coordinates
    var u : GLfloat = 0.0
    var v : GLfloat = 0.0
    
    // Normal
    var nx : GLfloat = 0.0
    var ny : GLfloat = 0.0
    var nz : GLfloat = 0.0
    
    init(_ x : GLfloat, _ y : GLfloat, _ z : GLfloat, _ r : GLfloat = 0.0, _ g : GLfloat = 0.0, _ b : GLfloat = 0.0, _ a : GLfloat = 1.0, _ u : GLfloat = 0.0, _ v : GLfloat = 0.0, _ nx : GLfloat = 0.0, _ ny : GLfloat = 0.0, _ nz : GLfloat = 0.0) {
        self.x = x
        self.y = y
        self.z = z
        
        self.r = r
        self.g = g
        self.b = b
        self.a = a
        
        self.u = u
        self.v = v
    
        self.nx = nx
        self.ny = ny
        self.nz = nz
    }
}

