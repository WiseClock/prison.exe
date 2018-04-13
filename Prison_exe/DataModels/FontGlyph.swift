//
//  FontGlyph.swift
//  Prison_exe
//
//  Created by Carl Kuang on 2018-04-12.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

import Foundation

struct FontGlyph
{
    let ID : Int
    let X : Float
    let Y : Float
    let Width : Float //width of character
    let Height : Float //height of character
    let OffsetX : Float
    let OffsetY : Float
    let AdvanceX : Float
    let Letter : Character
    
    init(_ id : Int, _ x : Float, _ y : Float, _ width : Float, _ height : Float, _ offsetX : Float, _ offsetY : Float, _ advanceX : Float, _ letter : Character)
    {
        self.ID = id
        self.X = x
        self.Y = y
        self.Width = width
        self.Height = height
        self.OffsetX = offsetX
        self.OffsetY = offsetY
        self.AdvanceX = advanceX
        self.Letter = letter
    }
}
