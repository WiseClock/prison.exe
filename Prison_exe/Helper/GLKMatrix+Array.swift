//
//  GLKMatrix+Array.swift
//
//  Created by Ryan Dieno on 2018-02-02.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import GLKit

// helper functions to turn matrices into an array

extension GLKMatrix2 {
    var array: [Float] {
        return (0..<4).map { i in
            self[i]
        }
    }
}

extension GLKMatrix3 {
    var array: [Float] {
        return (0..<9).map { i in
            self[i]
        }
    }
}

extension GLKMatrix4 {
    var array: [Float] {
        return (0..<16).map { i in
            self[i]
        }
    }
}

